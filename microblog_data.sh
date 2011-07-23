#! /bin/bash

# 2011-06.21 (mca) html5-microblog data for couchdb

clear
echo '2011-06-21 (mca) html5-microblog for couchdb'

echo 'creating db...'
curl -vX DELETE http://localhost:5984/html5-microblog
curl -vX PUT http://localhost:5984/html5-microblog

echo 'adding design document...'
curl -vX PUT http://localhost:5984/html5-microblog/_design/microblog -d @design-doc.json

echo 'adding users...'
curl -vX PUT http://localhost:5984/html5-microblog/mamund -d @user-mamund.json
curl -vX PUT http://localhost:5984/html5-microblog/lee -d @user-lee.json
curl -vX PUT http://localhost:5984/html5-microblog/benjamin -d @user-benjamin.json
curl -vX PUT http://localhost:5984/html5-microblog/mary -d @user-mary.json

echo 'testing user views...'
curl -v http://localhost:5984/html5-microblog/_design/microblog/_view/users_all
curl -v http://localhost:5984/html5-microblog/_design/microblog/_view/users_by_id?startkey=\"ma\"\&endkey=\"ma\\u9999\"

echo 'adding posts...'
curl -vX POST http://localhost:5984/html5-microblog/ -d @post1-mamund.json
curl -vX POST http://localhost:5984/html5-microblog/ -d @post2-mamund.json
curl -vX POST http://localhost:5984/html5-microblog/ -d @post1-lee.json
curl -vX POST http://localhost:5984/html5-microblog/ -d @benjamin-post1.json

echo 'testing post views...'
curl -v http://localhost:5984/html5-microblog/_design/microblog/_view/posts_all?descending=true
curl -v http://localhost:5984/html5-microblog/_design/microblog/_view/posts_by_user?descending=true\&key=\"mamund\"

echo 'adding follows...'
curl -vX POST http://localhost:5984/html5-microblog/ -d @follows-mamund.json
curl -vX POST http://localhost:5984/html5-microblog/ -d @follows-lee.json
curl -vX POST http://localhost:5984/html5-microblog/ -d @follows-benjamin.json
curl -vX POST http://localhost:5984/html5-microblog/ -d @follows-mamund2.json

echo 'testing follow views...'
curl -v http://localhost:5984/html5-microblog/_design/microblog/_view/follows_user_is_following?include_docs=true\&key=\"mamund\"
curl -v http://localhost:5984/html5-microblog/_design/microblog/_view/follows_is_following_user?include_docs=true\&key=\"mamund\"

curl -vX POST http://localhost:5984/html5-microblog/_design/microblog/_view/posts_by_user -d @posts_by_user.json

