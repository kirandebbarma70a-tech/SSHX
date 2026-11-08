# Ubuntu 20.04 बेस इमेज
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# ज़रूरी पैकेज इंस्टॉल करें
RUN apt-get update && \
    apt-get install -y curl wget tmux python3 python3-pip git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# sshx को इंस्टॉल करें
RUN curl -sSf https://sshx.io/get | sh

# Render के लिए पोर्ट 4200 को ओपन रखें
EXPOSE 4200

# स्टार्टअप स्क्रिप्ट: बैकग्राउंड टास्क + sshx + एक छोटा सा dummy HTTP server ताकि Render का पोर्ट स्कैन पास हो जाए
RUN echo '#!/bin/bash\n\
# 1. आपका मुख्य बैकग्राउंड टास्क\n\
tmux new-session -d -s my_running_code "while true; do echo \"Background task running...\"; sleep 10; done"\n\
\n\
# 2. Render को खुश रखने के लिए पोर्ट 4200 पर एक हल्का-फुल्का python HTTP सर्वर बैकग्राउंड में चलाएं\n\
python3 -m http.server 4200 --bind 0.0.0.0 &>/dev/null &\n\
\n\
# 3. sshx को चलाएं ताकि आपको टर्मिनल का लिंक मिल सके\n\
sshx\n' > /start.sh && chmod +x /start.sh

CMD ["/start.sh"]
