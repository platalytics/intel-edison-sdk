# Intel Edison SDK

Before you dive into setting up the SDK for your device, follow instructions below.

1. You need a Linux based environment (Mac works too) to setup
2. Make sure you have `expect` utility installed

    Get `expect` on Ubuntu/Debian
        
        $ sudo apt-get install expect

Add execution permissions to script `deploy.sh`

    $ chmod +x deploy.sh

Run deployment script

    $ ./deploy.sh -<option1> <value1> ...
	    -i IP address
        -u username having root access
        -p password of specified username
        -s SSH port
        -d device ID/key generated from Platalytics Platform
        -f frontend host

Example
    
    $ ./deploy -i 192.168.1.X -u root -p arduino -s 22 -d KEY -f [url]

You can find example sketch programs in `examples/` folder.