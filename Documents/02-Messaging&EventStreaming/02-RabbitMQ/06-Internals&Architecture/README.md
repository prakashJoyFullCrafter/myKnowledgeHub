# RabbitMQ Internals & Architecture - Curriculum

Deep dive into how RabbitMQ is built — Erlang VM, Mnesia, message store, queue processes, and flow control.

---

## Module 1: Erlang VM Foundations
- [ ] **Why Erlang?**: built for telecom — massive concurrency, fault tolerance, hot code reload
- [ ] **Erlang processes**: lightweight green threads (NOT OS threads), millions per node
  - [ ] Each process has isolated memory (no shared state)
  - [ ] Communication via message passing
- [ ] **Supervisor trees**: "let it crash" philosophy, automatic restart on failure
  - [ ] Each queue is supervised — crash in one doesn't affect others
- [ ] **BEAM VM**: the Erlang runtime, highly optimized for concurrency
- [ ] **Scheduler**: one per CPU core, preemptive scheduling of Erlang processes
- [ ] **Benefits for RabbitMQ**:
  - [ ] Handle 100K+ connections per node
  - [ ] Queue isolation (crash in one queue ≠ broker failure)
  - [ ] Low-latency message passing
- [ ] **Cost**: Erlang is not Java/Python — unusual language, smaller ecosystem

## Module 2: Queue Process Model
- [ ] **Each queue is ONE Erlang process** (classic queue)
- [ ] **Queue state**: in-memory data structure (message list, consumer list, state)
- [ ] **Consumers** send `basic.consume` → subscribe to the queue process
- [ ] **Publishers** send messages → exchange process → routes → queue process
- [ ] **Per-queue throughput limit**: a single queue process can process 50K-100K msg/sec max
- [ ] **Scaling**: multiple queues for parallelism (not multiple threads on one queue)
- [ ] **Queue home node**: each classic queue lives on ONE node (unless mirrored)
  - [ ] Publishers/consumers route to home node via cluster metadata
  - [ ] Cross-node traffic = extra hop
- [ ] **Quorum queue**: queue as distributed state machine (Raft), still one "leader" process

## Module 3: Mnesia Metadata Database
- [ ] **Mnesia**: Erlang's built-in distributed database
- [ ] **What RabbitMQ stores in Mnesia**:
  - [ ] Vhosts, users, permissions, policies
  - [ ] Exchanges, queues (metadata, NOT messages)
  - [ ] Bindings
  - [ ] Cluster membership, runtime parameters
- [ ] **Replication**: metadata is replicated to all cluster nodes (disc nodes persist it)
- [ ] **RAM nodes vs disc nodes**:
  - [ ] Disc node: Mnesia written to disk, survives restart
  - [ ] RAM node: Mnesia in memory only, faster but stateless
  - [ ] Recommendation: all disc nodes for production
- [ ] **Mnesia is fragile at scale**:
  - [ ] Network partitions can split Mnesia → data divergence
  - [ ] Large metadata (millions of queues) causes performance issues
- [ ] **KRaft replacement project** (RabbitMQ Khepri): replacing Mnesia with Raft-based store
  - [ ] Preview in 3.13+, eventual default

## Module 4: Message Store
- [ ] **Classic queue persistent messages**: written to per-node message store
- [ ] **Message store structure**:
  - [ ] Shared message store (across all queues on that node)
  - [ ] Files on disk under `msg_store_persistent/` and `msg_store_transient/`
  - [ ] Index tracks which messages are where
- [ ] **Queue-internal vs message store**:
  - [ ] Small messages: stored IN the queue process memory
  - [ ] Large messages: stored in shared message store, queue keeps a reference
  - [ ] Threshold: `queue_index_embed_msgs_below` (default 4096 bytes)
- [ ] **Garbage collection**: when messages are consumed, space is reclaimed
- [ ] **Quorum queues**: different storage (Raft log files, optimized for replication)
- [ ] **Streams**: append-only segment files (similar to Kafka)
- [ ] **Trade-off**: classic queue fastest for small messages, stream fastest for bulk retention

## Module 5: Delivery Process (End-to-End Flow)
- [ ] **Publish flow**:
  1. [ ] Client sends `basic.publish` over channel
  2. [ ] Channel process receives, looks up exchange
  3. [ ] Exchange process routes (based on type) → list of queues
  4. [ ] For each queue: send message to queue process
  5. [ ] Queue process appends to its internal state
  6. [ ] If persistent + durable: write to message store
  7. [ ] (Optional) Publisher confirm sent back to client
- [ ] **Deliver flow**:
  1. [ ] Consumer subscribes (`basic.consume`) — channel registers with queue process
  2. [ ] Queue process holds outbound "ready" queue
  3. [ ] When consumer has capacity (prefetch not full), queue pushes message to channel
  4. [ ] Channel sends to consumer over TCP
  5. [ ] Consumer processes, sends `basic.ack`
  6. [ ] Queue process removes message, updates state
- [ ] **Per-message Erlang process hops**: publish = 3-4 hops; deliver = 3 hops
- [ ] **Optimizations**: batching, inline processing, selective persistence

## Module 6: Flow Control (Credit-Based)
- [ ] **Problem**: fast publishers can overwhelm slow queues/consumers
- [ ] **Flow control**: RabbitMQ slows down publishers when broker is under pressure
- [ ] **Credit-based flow control** (Erlang-level):
  - [ ] Each process grants "credits" to senders
  - [ ] When sender runs out of credits → blocks until more granted
  - [ ] Protects the whole Erlang VM from overload
- [ ] **Connection-level blocking**:
  - [ ] Slow queue → channel blocks → connection blocks → client blocked on `basic.publish`
  - [ ] Client sees slower publish rate (not errors)
- [ ] **Memory alarm**: when broker memory > high watermark, ALL publishing stops
  - [ ] Default: 40% of RAM
  - [ ] Blocks new publishes, allows consumers to drain
- [ ] **Disk alarm**: when disk free space < threshold, ALL publishing stops
  - [ ] Default: 50 MB free
- [ ] **Monitoring**: `flow` state on connection indicates backpressure

## Module 7: Channel & Connection Model Internals
- [ ] **Connection**: one Erlang process for the TCP connection
- [ ] **Channel**: one Erlang process per channel, supervised by connection
- [ ] **Why channels**: multiplex many concurrent operations over one TCP
- [ ] **Channel state**: outstanding acks, prefetch state, transaction state
- [ ] **Per-channel cost**: small (a few KB of memory)
- [ ] **Per-connection cost**: larger (TCP socket, file descriptor, buffers)
- [ ] **Recommendation**: few connections, many channels (NOT many connections)
- [ ] **Connection churn**: rapid open/close of connections is expensive
- [ ] **Channel leak**: channels not closed properly → broker memory grows

## Module 8: Garbage Collection & Memory Management
- [ ] **Per-process GC**: each Erlang process has its own heap and GC
  - [ ] No global GC pause (unlike JVM)
  - [ ] GC cost is proportional to process size
- [ ] **Binary heap**: large binaries (> 64 bytes) shared in a global pool
  - [ ] Ref-counted, can cause subtle memory issues
- [ ] **Memory usage breakdown** (`rabbitmqctl status`):
  - [ ] Queue memory (queue state)
  - [ ] Message store (persistent message data)
  - [ ] Mnesia (metadata)
  - [ ] Binary heap (shared binaries)
  - [ ] Connections, channels, other processes
- [ ] **Memory spikes**: GC lag, large message burst, connection surge
- [ ] **Tuning**:
  - [ ] `vm_memory_high_watermark` (default 0.4 = 40% RAM)
  - [ ] `vm_memory_high_watermark_paging_ratio` (start paging at 50% of watermark)
- [ ] **Paging**: move queue contents to disk when memory pressure high

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Read about Erlang VM basics (OTP principles, let-it-crash philosophy) |
| Module 2 | Observe per-queue processes in `rabbitmqctl list_queues` with memory column |
| Module 3 | Inspect Mnesia tables via `rabbitmqctl eval 'mnesia:info().'` |
| Module 4 | Find and inspect message store files on a broker's data directory |
| Module 5 | Enable `channel_operation_timeout` logging, trace a publish end-to-end |
| Module 6 | Trigger memory alarm by pushing large backlog, observe publish blocking |
| Module 7 | Open many channels on one connection, observe resource usage |
| Module 8 | Monitor memory breakdown with Management UI or `rabbitmqctl status` |

## Key Resources
- "RabbitMQ Internals" — rabbitmq.com/blog category
- "Erlang and RabbitMQ" — Alvaro Videla blog
- "RabbitMQ in Depth" — Gavin Roy (Chapter 8)
- Mnesia documentation (erlang.org)
- "RabbitMQ Runtime Resource Usage" — rabbitmq.com/memory-use.html
- "RabbitMQ Flow Control" — rabbitmq.com/flow-control.html
