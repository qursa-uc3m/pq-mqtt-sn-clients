# MQTT-SN Clients with wolfMQTT Library for PQC Testing

This repository contains MQTT-SN clients based on [wolfMQTT](https://github.com/wolfSSL/wolfMQTT)'s [wolfMQTT/examples/sn-client](https://github.com/wolfSSL/wolfMQTT/tree/master/examples/sn-client)

## Build wolfSSL and wolfMQTT

### wolfSSL

Clone this repository and navigate to the project directory.
Run the wolfSSL installation script:

```bash
./install_wolfssl.sh
```

By default, this script installs wolfSSL version `5.6.4-stable`. You can change the version by modifying the `INSTALL_TAG` variable in the `install_wolfssl.sh` script.

### wolfMQTT

After installing wolfSSL, install wolfMQTT:

```bash
./install_wolfMQTT.sh
```

By default, this script installs wolfMQTT version `1.19.0`. You can change the version by modifying the `INSTALL_TAG` variable in the `install_wolfMQTT.sh` script.

Note: Ensure that the versions of wolfSSL and wolfMQTT are compatible with each other and with the MQTT-SN clients in this repository.

## Build the project

```bash
mkdir build
cd build
cmake ..
make
```

## Running the clients

To run the MQTT-SN client:

```bash
./build/bin/sn-client -t 
```

To run the MQTT-SN publisher:

```bash
./build/bin/sn-pub -t 
```

To run the MQTT-SN subscriber:

```bash
./build/bin/sn-sub -t 
```