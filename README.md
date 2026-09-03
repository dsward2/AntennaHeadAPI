# AntennaHeadAPI

The Codable data contract between AntennaHead's HTTP server and any
non-WebKit client — currently scoped for a tvOS app and a watchOS app (see
the feasibility study this package implements the first phase of). AntennaHead
imports it to *encode* responses; native SwiftUI clients import the same
package to *decode* them, so a schema change becomes a compiler error on
every client instead of a runtime mismatch discovered in the field.

This is a sibling repo in the `antennahead-umbrella` workspace, following the
same manifest+bootstrap convention as `PipelineHelpers`, `AirPlayReceiver`,
and `SharedLogging` — see `antennahead-workspace/README.md`.

## Status: wired up, powering a real client

Imported by `AntennaHeadHTTPServer` (the `/api/v1/...` routes, additive
alongside every existing `*.html` route) and by
[AntennaHeadTV](https://github.com/dsward2/AntennaHeadTV), the tvOS client
that's exercised the whole contract end to end on real hardware — including
audio playback via the HLS mount these types don't cover directly (that's a
separate, pre-existing route; see `AntennaHeadTV`'s README).

## What's here

| File | Purpose |
|---|---|
| `TaskMode` | Mirrors `SDRController.TaskMode` — what the tuner is currently doing. |
| `FrequencySummary` | Client-facing view of a "favorite" (a `Frequency` row). Deliberately **not** a mirror of the full ~20-field database record — see its doc comment. |
| `CategorySummary` | Client-facing view of a `Category` row, same reasoning. |
| `NowPlayingStatus` | Replaces the ad hoc dictionary `nowPlayingStatusJSON()` builds today for `/nowplayingstatus.html`. |
| `AACRecorderStatus` | Matches the existing `/api/aac-recorder/status` JSON shape as-is — that endpoint was already client-shaped. |
| `DeviceSummary` | A Core Audio input device (mirrors `AudioInputDevices.names()`); the name doubles as its ID. |
| `RecordingSummary` | A file in the shared Recordings folder, carrying a ready-to-use `downloadPath` for AntennaHead's existing Range-capable `/recordings-download/...` route — see its doc comment for why playback goes through that route rather than a new one. |
| `ControlBoothStatus` | Whether ControlBooth is running and, if so, its pipeline names (mirrors `controlBoothPageHTML()`). |
| `TuneFrequencyRequest`, `StartCategoryScanRequest`, `StartDeviceRequest`, `StartControlBoothPipelineRequest` | Request bodies for the JSON-API equivalents of the corresponding `*listenbuttonclicked.html` form POSTs. |
| `APIError` | Matches the existing `{"error": ...}` shape from `jsonErrorResponse(_:status:)`. |
| `APIEndpoint` | Named route constants under `/api/v1/...` — additive, zero collision risk against the existing `*.html` fragment routes or the pre-existing `/api/aac-recorder/*` routes. |
| `APIVersion` | Single source of truth for the schema version; not yet wired into any response. |

## Design decisions worth knowing before extending this

- **Summaries, not database records.** `Frequency`/`Category` in AntennaHead
  carry SDR-tuning-internal fields (tuner gain, FIR size, atan math mode,
  ...) that configure the Mac's local `rtl_fm_localradio` pipeline. A remote
  client has no use for them and every tuning-internals change on the Mac
  would otherwise become a breaking change for every client. If a future
  client needs to *edit* tuning parameters, that calls for a new,
  explicitly-versioned type — don't widen `FrequencySummary`.
- **No dependency on GRDB, PipelineHelpers, or anything AntennaHead-internal.**
  Keeps this a lightweight leaf package any target on any Apple platform can
  adopt, and keeps `TaskMode` here as an independent declaration that the
  server keeps in sync with `SDRController.TaskMode` (a non-exhaustive
  `switch` on either side is the intended guardrail against drift).
- **`/api/v1/` namespace.** Chosen so a future incompatible v2 can be served
  side-by-side during a client migration instead of forcing a flag day, and
  so none of this collides with the existing `*.html` routes.

## Next steps

1. Stand up a watchOS app target that imports this package — the tvOS client
   is the only consumer so far.
2. Bonjour-based discovery and HTTPS/Basic Auth support, both still open in
   every client (see the feasibility study and each client's own README).
3. Now that there's a real client, consider upgrading `/api/v1/now-playing`
   from polling to a push channel (SSE/WebSocket).

## Building

```bash
swift build
swift test
```
