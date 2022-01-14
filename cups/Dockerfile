FROM lemariva/rpi-cups

RUN sudo apt update && \
    sudo apt upgrade -y && \
    sudo apt autoremove

ENTRYPOINT [ "sudo", "cupsctl", "--remote-any" ]
