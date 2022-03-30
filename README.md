# Yolks

A curated collection of core images that can be used with Pterodactyl's Egg system. 

Forked from [pterodactyl/yolks](https://github.com/pterodactyl/yolks).

## Available Images

* [`Amazon Corretto 17`](https://github.com/arima0k/yolks/tree/master/java)
  * [`Amazon Corretto 17`](https://github.com/arima0k/yolks/tree/master/java/17corretto)
    * `ghcr.io/arima0k/yolks:java_17corretto`
  * [`Paper auto update`](https://github.com/arima0k/yolks/tree/master/java/17paper)
    * `ghcr.io/arima0k/yolks:java_17paper`
  * [`Velocity auto update`](https://github.com/arima0k/yolks/tree/master/java/17velocity)
    * `ghcr.io/arima0k/yolks:java_17velocity`
  * [`GeyserMC`](https://github.com/arima0k/yolks/tree/master/java/17geysermc)
    * `ghcr.io/arima0k/yolks:java_17geysermc`

## Note

The auto update images require a custom egg, can be found on [`arima0k/eggs`](https://github.com/arima0k/Pterodactyl-eggs)

Make sure to fix the minecraft version on the `MINECRAFT_VERSION` variable so it won't jump versions automatically, example from 1.18.2 to 1.19.1.
