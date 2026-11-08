# Ubuntu 20.04 को बेस इमेज के तौर पर इस्तेमाल करें
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# ज़रूरी पैकेज इंस्टॉल करें
RUN apt-get update && \
    apt-get install -y tmux curl wget python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Gotty डाउनलोड करें (मोबाइल वर्चुअल कीबोर्ड और एंटर की के लिए सबसे बेस्ट)
RUN wget https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz && \
    tar -xzf gotty_linux_amd64.tar.gz && \
    mv gotty /usr/local/bin/ && \
    rm gotty_linux_amd64.tar.gz

EXPOSE 4200

# स्टार्टअप स्क्रिप्ट: बैकग्राउंड टास्क + Gotty टर्मिनल
RUN echo '#!/bin/bash\n\
tmux new-session -d -s my_running_code "while true; do echo \"Background task running...\"; sleep 10; done"\n\
exec gotty -w --port 4200 bash\n' > /start.sh && chmod +x /start.sh

CMD ["/start.sh"]
