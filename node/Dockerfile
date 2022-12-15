FROM node:lts

ARG USERNAME

RUN groupadd ${USERNAME} \
    && useradd --shell /bin/bash --create-home ${USERNAME} -g ${USERNAME} \
    && usermod -aG node ${USERNAME} \
    && usermod -aG ${USERNAME} node

RUN npm install -g npm@latest
RUN yarn global add express body-parser mongoose
RUN yarn add express body-parser mongoose --save

RUN yarn global add nodemon
RUN yarn global add npm-add-script
