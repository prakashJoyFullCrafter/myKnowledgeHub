# Kotlin Coroutines - Curriculum

## Module 1: Coroutine Basics
- [ ] What are coroutines? Lightweight threads
- [ ] `suspend` functions
- [ ] `runBlocking` - bridge between blocking and coroutine world
- [ ] `launch` - fire-and-forget (returns `Job`)
- [ ] `async` / `await` - returns `Deferred<T>` with result
- [ ] `delay()` vs `Thread.sleep()`
- [ ] Structured concurrency - why it matters

## Module 2: Coroutine Scope & Context
- [ ] `CoroutineScope` - lifecycle management
- [ ] `GlobalScope` - why to avoid it
- [ ] `CoroutineContext` - combination of elements
- [ ] `Job` - lifecycle, cancellation, parent-child relationship
- [ ] `SupervisorJob` - independent child failure
- [ ] `coroutineScope` vs `supervisorScope`

## Module 3: Dispatchers
- [ ] `Dispatchers.Default` - CPU-intensive work
- [ ] `Dispatchers.IO` - I/O operations
- [ ] `Dispatchers.Main` - UI thread
- [ ] `Dispatchers.Unconfined` - starts in caller thread
- [ ] `withContext()` - switch dispatcher
- [ ] Custom dispatchers

## Module 4: Cancellation & Timeouts
- [ ] Cooperative cancellation - `isActive` check
- [ ] `cancel()` and `CancellationException`
- [ ] `ensureActive()` and `yield()`
- [ ] Non-cancellable blocks: `withContext(NonCancellable)`
- [ ] `withTimeout()` and `withTimeoutOrNull()`

## Module 5: Flows
- [ ] `Flow<T>` - cold asynchronous stream
- [ ] `flow { emit() }` builder
- [ ] Terminal operators: `collect`, `toList`, `first`, `reduce`
- [ ] Intermediate operators: `map`, `filter`, `transform`, `take`
- [ ] `onEach`, `onStart`, `onCompletion`, `catch`
- [ ] `flowOn()` for changing dispatcher
- [ ] `conflate()`, `buffer()`, `collectLatest()`

## Module 6: StateFlow & SharedFlow
- [ ] `StateFlow` - observable state holder (hot)
- [ ] `MutableStateFlow` - emit new state
- [ ] `SharedFlow` - event broadcasting (hot)
- [ ] `stateIn()` and `shareIn()` - convert cold Flow to hot

## Module 7: Channels
- [ ] `Channel` - communication between coroutines
- [ ] Channel types: Rendezvous, Buffered, Conflated, Unlimited
- [ ] `produce` builder
- [ ] Fan-out and fan-in patterns
- [ ] Channel vs Flow - when to use which

## Module 8: Exception Handling & Testing
- [ ] `try-catch` in coroutines
- [ ] `CoroutineExceptionHandler`
- [ ] Exception propagation in `launch` vs `async`
- [ ] `runTest` for testing suspend functions
- [ ] `Turbine` library for testing Flows

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-3 | Fetch data from multiple APIs concurrently |
| Module 4 | Implement a cancellable file download with progress |
| Modules 5-6 | Build a search-as-you-type with debounce using Flow |
| Modules 7-8 | Build a producer-consumer pipeline with tests |

## Key Resources
- Kotlin Coroutines official guide
- Kotlin Coroutines: Deep Dive - Marcin Moskala
