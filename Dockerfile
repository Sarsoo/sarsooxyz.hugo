FROM registry.sarsoo.xyz/sarsoo/hugo:latest AS build

COPY . /sarsooxyz.hugo
WORKDIR /sarsooxyz.hugo

RUN hugo \
    --minify \
    --baseURL https://sarsoo.xyz/

FROM nginx
COPY --from=build /sarsooxyz.hugo/public /usr/share/nginx/html/