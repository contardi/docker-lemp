FROM node:lts

ARG USERNAME

RUN groupadd ${USERNAME} \
    && useradd --shell /bin/bash --create-home ${USERNAME} -g ${USERNAME} \
    && usermod -aG node ${USERNAME} \
    && usermod -aG ${USERNAME} node

RUN yarn add express body-parser mongoose --save

RUN yarn global add nodemon --save
