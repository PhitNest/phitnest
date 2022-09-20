# Running the backend locally

To run the backend, navigate to the `backend` directory, and run the following commands:

```
npm install
npm run dev
```

Replace the contents of `phitnest_mobile/.env` with the following:

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
