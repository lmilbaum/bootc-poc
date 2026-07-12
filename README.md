# bootc-poc

Builds a Fedora bootc image with RKE2 preinstalled.

## Build

```bash
make build
```

## Push

```bash
make push
```

## Use from bootc

```bash
bootc install to-existing-root \
  --source-imgref quay.io/<your-quay-user>/bootc-poc:latest
```

