FROM git.sarsoo.xyz/sarsoo/hugo:latest AS build

COPY . /sarsooxyz.hugo
WORKDIR /sarsooxyz.hugo

RUN hugo \
    --minify \
    --baseURL sarsoo.xyz

FROM nginx
COPY --from=build /sarsooxyz.hugo/public /usr/share/nginx/html/