# Content Delivery Network (CDN) - Curriculum

## Module 1: CDN Fundamentals
- [ ] What is a CDN? Geographically distributed network of proxy servers
- [ ] **Edge servers** and **Points of Presence (PoPs)**: serving content close to users
- [ ] How CDN works: user → nearest edge → cache hit (fast) or cache miss (fetch from origin)
- [ ] Benefits: reduced latency, reduced origin load, DDoS protection, high availability
- [ ] CDN for static content: images, CSS, JS, fonts, videos
- [ ] CDN for dynamic content: API responses, personalized pages (with short TTL)

## Module 2: Push vs Pull CDN
- [ ] **Pull CDN**: edge fetches from origin on cache miss, caches for TTL
  - [ ] Lazy loading, no upfront work, most common
  - [ ] First request to each edge is slow (cold cache)
- [ ] **Push CDN**: you upload content directly to CDN nodes
  - [ ] Good for large, infrequently changing files (videos, software downloads)
  - [ ] You control exactly what's cached and when
- [ ] Most CDNs use pull model; push is for specific use cases

## Module 3: Cache Control & Invalidation
- [ ] **Cache-Control headers**: `max-age`, `s-maxage`, `no-cache`, `no-store`, `public`, `private`
- [ ] **TTL (Time to Live)**: how long edge caches content before revalidating
- [ ] **ETag** and **If-None-Match**: conditional requests for cache validation
- [ ] **Invalidation strategies**:
  - [ ] TTL expiry: simplest, but stale content during TTL window
  - [ ] Purge/flush: manually invalidate specific URLs or all content
  - [ ] Versioned URLs: `style.v2.css` or `style.css?v=abc123` — never stale
  - [ ] Stale-while-revalidate: serve stale, fetch fresh in background
- [ ] Cache key: what makes two requests "the same" (URL, headers, cookies, query params)

## Module 4: CDN Architecture & Features
- [ ] **Origin Shield**: intermediate cache between edge and origin — reduces origin hits
- [ ] **Multi-CDN**: using multiple CDN providers for redundancy and performance
- [ ] **Edge computing**: running logic at edge (Cloudflare Workers, Lambda@Edge)
- [ ] **TLS termination** at edge: HTTPS without load on origin
- [ ] **DDoS protection**: absorb attacks at edge before reaching origin
- [ ] **Image optimization**: automatic resizing, format conversion (WebP/AVIF) at edge
- [ ] **Video streaming**: adaptive bitrate (HLS, DASH) with CDN

## Module 5: CDN Providers & Practice
- [ ] **CloudFront** (AWS): integrates with S3, Lambda@Edge, WAF
- [ ] **Cloudflare**: DNS + CDN + security, free tier, Workers for edge compute
- [ ] **Akamai**: largest CDN, enterprise-focused
- [ ] **Fastly**: real-time purging, Varnish-based, edge compute (Compute@Edge)
- [ ] Choosing a CDN: cost model (bandwidth vs requests), PoP coverage, features
- [ ] CDN monitoring: cache hit ratio, origin offload %, latency percentiles

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Set up CloudFront in front of an S3 bucket for static assets |
| Module 3 | Configure Cache-Control headers, test TTL and purge behavior |
| Module 4 | Set up Origin Shield, measure origin request reduction |
| Module 5 | Compare CDN performance across providers for your region |

## Key Resources
- Cloudflare Learning Center (excellent free resource)
- AWS CloudFront documentation
- "CDN" chapter in System Design Interview - Alex Xu
- Web.dev caching best practices (Google)
