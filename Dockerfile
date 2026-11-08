# Ubuntu 20.04 बेस इमेज
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# ज़रूरी पैकेज इंस्टॉल करें (shellinabox, tmux और अन्य टूल्स)
RUN apt-get update && \
    apt-get install -y shellinabox tmux curl wget python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 4200

# स्टार्टअप स्क्रिप्ट: यह आपके बैकग्राउंड कोड को भी चलाएगा और 
# shellinabox को बिना किसी लॉगिन/पासवर्ड प्रॉम्प्ट के सीधे डायरेक्ट Bash टर्मिनल पर सेट कर देगा
RUN echo '#!/bin/bash\n\
# यहाँ आपका मुख्य बैकग्राउंड टास्क चलेगा (आप चाहें तो अपनी स्क्रिप्ट यहाँ लगा सकते हैं)\n\
tmux new-session -d -s my_running_code "while true; do echo \"Background task running...\"; sleep 10; done"\n\
\n\
# shellinabox को बिना लॉगिन के सीधे root का bash शेल खोलने के लिए कॉन्फ़िगर करें\n\
exec /usr/bin/shellinaboxd -t -s "/:root:root:/:/bin/bash"\n' > /start.sh && chmod +x /start.sh

CMD ["/start.sh"]
