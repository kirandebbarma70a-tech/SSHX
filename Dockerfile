# Ubuntu 20.04 को बेस इमेज के तौर पर इस्तेमाल करें
FROM ubuntu:20.04

# नॉन-इन्टरेक्टिव मोड ताकि इंस्टॉलेशन में कोई रुकावट न आए
ENV DEBIAN_FRONTEND=noninteractive

# ज़रूरी पैकेज इंस्टॉल करें (shellinabox, tmux, curl, wget, python3)
RUN apt-get update && \
    apt-get install -y shellinabox tmux curl wget python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# root यूज़र के लिए पासवर्ड सेट करें
RUN echo 'root:root' | chpasswd

# वेब-आधारित टर्मिनल पोर्ट को एक्सपोज़ करें
EXPOSE 4200

# स्टार्टअप स्क्रिप्ट बनाएँ जो कंटेनर शुरू होते ही आपके कोड को हमेशा के लिए बैकग्राउंड में चला देगी
RUN echo '#!/bin/bash\n\
# 1. एक बैकग्राउंड tmux सेशन बनाएँ और उसमें अपना मुख्य कोड/प्रॉक्सी चलाएँ\n\
# (यहाँ 'while true' की जगह आप अपनी कोई भी पायथन स्क्रिप्ट या प्रॉक्सी कमांड लिख सकते हैं)\n\
tmux new-session -d -s my_running_code "while true; do echo \"Code is running...\"; sleep 10; done"\n\
\n\
# 2. shellinaboxd को शुरू करें ताकि आप जब चाहें टर्मिनल एक्सेस कर सकें\n\
exec /usr/bin/shellinaboxd -t -s "/:LOGIN"\n' > /start.sh && chmod +x /start.sh

# कंटेनर शुरू होने पर /start.sh स्क्रिप्ट अपने आप चल जाएगी
CMD ["/start.sh"]
