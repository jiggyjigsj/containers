FROM lemariva/rpi-cups

RUN sudo apt-get update && \
    sudo apt-get upgrade -y && \
    sudo apt-get autoremove

ENTRYPOINT [ "sudo cupsctl --remote-any" ]
