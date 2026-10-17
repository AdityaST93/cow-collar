# Contributing

Madad ka swagat hai: bug fix, behaviour thresholds ka asli data, naye sensor, translations, docs.

## Setup

```bash
git clone <repo-url> && cd cow-collar
npm test          # koi install nahi chahiye, Node 18+
npm start         # server
npm run demo      # nakli jhund (doosre terminal mein)
```

## Niyam

- Backend aur `shared/` mein **zero npm dependency** rakho. Ye is project ka maksad hai.
- Logic badlo to `shared/*.js` aur `firmware/collar/collar.ino` dono mein, aur test jodo.
- Fence/behaviour ke thresholds badalte waqt PR mein wajah aur (ho sake to) data likho.
- Animal-welfare limits (`MAX_PULSES` waghera) badhane ka PR tabhi, jab vet ki salah ka hawala ho.
- Secrets (Wi-Fi password, API key) kabhi commit mat karo. `config.local.h` use karo.
- Firmware mein jo cheez asli hardware par test nahi hui, PR mein saaf likho.

## Pull request se pehle

`npm test` poora paas hona chahiye. CI teen Node versions par ye hi chalata hai.
