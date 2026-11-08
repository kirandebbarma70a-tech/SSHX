# Ubuntu 20.04 बेस इमेज
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# ज़रूरी पैकेज इंस्टॉल करें
RUN apt-get update && \
    apt-get install -y curl wget tmux python3 python3-pip git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# sshx को इंस्टॉल करें (यह मोबाइल और डेस्कटॉप दोनों के लिए सबसे फास्ट वेब टर्मिनल है)
RUN curl -sSf https://sshx.io/get | sh

# Render के लिए पोर्ट 4200
EXPOSE 4200

# स्टार्टअप स्क्रिप्ट: बैकग्राउंड टास्क + sshx टर्मिनल लिंक जनरेटर
RUN echo '#!/bin/bash\n\
# 1. बैकग्राउंड में आपका मुख्य कोड हमेशा चलता रहेगा\n\
tmux new-session -d -s my_running_code "while true; do echo \"Background task running...\"; sleep 10; done"\n\
\n\
# 2. sshx को चलाएं (यह टर्मिनल का वेब लिंक सीधे कंसोल में जनरेट कर देगा)\n\
sshx\n' > /start.sh && chmod +x /start.sh

CMD ["/start.sh"]
