# Cow Collar

A smart collar for cows and buffaloes: a **virtual fence** (digital boundary) plus a **behaviour monitor** (grazing, walking, resting, ruminating, restless).

The repo contains a browser simulator, a live dashboard, a Node.js backend and reference ESP32 firmware. The backend and dashboard have **no npm dependencies**.

## Live demo

**Try it in your browser, nothing to install:** https://&lt;your-username&gt;.github.io/cow-collar/

This is the offline simulator: animals graze, walk and rest inside a digital boundary, and you can watch warnings, fence crossings and restless alerts happen live. (Replace `<your-username>` with your GitHub username. The page goes live after you enable Pages, see "Publish the live demo" below.)

> **Status:** the server, dashboard, simulator and shared logic are tested (21 automated tests). The ESP32 firmware is **reference code that has not been tested on real hardware, and has not been compile-verified in the Arduino IDE**. Bench-test it before putting it on an animal.

## How it works

```
 Collar (ESP32 + GPS + accelerometer)            Gateway (ESP32 + LoRa + Wi-Fi)           Server (Node.js)
 ┌──────────────────────────────────┐  LoRa   ┌───────────────────────────┐  HTTPS   ┌───────────────────────┐
 │ fence check on the collar        │ ──────► │ packet -> JSON            │ ───────► │ fence + behaviour     │
 │ sound / vibration warning        │ ◄────── │ fence polygon broadcast   │ ◄─────── │ events, stats, SSE    │
 │ 5 s motion window -> features    │  fence  └───────────────────────────┘  fence   │ dashboard (Leaflet)   │
 └──────────────────────────────────┘                                                 └───────────────────────┘
```

- **The collar enforces the fence itself**, so the animal stays protected even when there is no network.
- **Escalation:** a warning sound first (when approaching the boundary from inside), one vibration when the line is crossed, and **no further stimulation after 3 crossings in 5 minutes**. After that the farmer is only alerted.
- **Behaviour** is derived from GPS speed, acceleration, head pitch and jaw rhythm (`shared/behavior.js`).

## Quick start (5 minutes, no hardware)

Requires [Node.js](https://nodejs.org) 18 or newer.

```bash
git clone <your-repo-url> cow-collar
cd cow-collar
npm start                 # server on http://localhost:3000
```

In a second terminal, start a fake herd:

```bash
npm run demo              # 9 simulated collars post data to the server
```

Then open:

| Page | What it is |
| --- | --- |
| http://localhost:3000/dashboard/ | Live map, fence, each animal's state and events. Tap the map to **edit the fence** |
| http://localhost:3000/simulator/ | Fully offline simulator (works without the server; you can also open the HTML file directly) |

Run the tests with `npm test` (21 tests, nothing to install).

### Publish the live demo

The simulator is published to GitHub Pages by `.github/workflows/pages.yml`. One-time setup: on GitHub open **Settings → Pages** and set **Source** to **GitHub Actions**, then push to `main` (or run the "Live demo" workflow manually). The dashboard needs the Node server, so only the simulator is hosted on Pages.

### Secure the server

Set an **API key** before exposing the server to the internet, otherwise anyone can write data:

```bash
API_KEY=your-long-secret-key npm start
npm run demo -- --key your-long-secret-key
```

With Docker:

```bash
API_KEY=your-long-secret-key docker compose up -d --build
```

Put Caddy or nginx in front of the server for HTTPS. Details in [docs/API.md](docs/API.md).

## Repository layout

```
shared/        geofence.js, behavior.js   (same logic in the server, dashboard and tests)
server/        server.js                  zero-dependency backend + static hosting
web/           simulator/  dashboard/
firmware/      collar/     gateway/       ESP32 Arduino sketches
tools/         fake-collar.js             simulated herd (demo)
test/          node --test tests
docs/          HARDWARE.md  HOW_IT_WORKS.md  API.md
```

## Documentation

- [docs/HARDWARE.md](docs/HARDWARE.md): parts list, wiring, flashing, bench test, animal welfare
- [docs/HOW_IT_WORKS.md](docs/HOW_IT_WORKS.md): fence escalation, behaviour thresholds, limitations
- [docs/API.md](docs/API.md): REST and SSE endpoints, telemetry format, deployment
- [CONTRIBUTING.md](CONTRIBUTING.md): how to help

## Known limitations

- **Firmware is untested on real hardware** and not compile-verified. Bench-test with the buzzer and a dummy load first.
- Behaviour thresholds are hand-set, not trained on real cattle data. You will need to tune them with your own herd's data.
- GPS accuracy is typically 2-5 m, so keep the warning distance at 10 m or more.
- **No electric stimulator by default.** Use sound and vibration only. Any stimulator needs veterinary advice and a check of your local law first.
- The collar-to-gateway LoRa range must be measured in your own field.

## Contributing and license

Pull requests are welcome, see [CONTRIBUTING.md](CONTRIBUTING.md). License: [MIT](LICENSE).
