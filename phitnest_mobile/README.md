# Documentation Videos

<a href="https://drive.google.com/file/d/1nAqiDd6KK6wRXIsCiL_kyeRbILgp5uyr/view?usp=sharing">1. Creating a Screen</a>

# Running the backend locally

To run the backend, navigate to the `backend` directory, and run the following commands:

```
npm install
npm run dev
```

Then, replace the contents of `phitnest_mobile/.env` with the following:

For android emulators:

```
BACKEND_HOST="10.0.2.2"
BACKEND_PORT="3000"
```

For iOS emulators:

```
BACKEND_HOST="127.0.0.1"
BACKEND_PORT="3000"
```
