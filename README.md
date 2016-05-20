# Intel Edison SDK

Before you dive into setting up the SDK for your device there are some instructions that need to be followed along.

1. You need a `linux`-based environment to setup
2. Make sure you have `expect` utility installed

    Get on **Ubuntu** executing following command in terminal
        
        $ sudo apt-get install expect

Add execution permissions to script `deploy.sh`

    $ chmod +x deploy.sh

Run deployment script

    $ ./deploy.sh <board-ip> <board-username> <board-password> <device-key> <host> <api-key>

This does everything in one go. Sets up protocol libraries and installs required dependencies on Intel Edison board.

You can find example sketch programs in `examples/` folder.
