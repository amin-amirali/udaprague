ADD JAR auxlib/json-serde-1.1.6-SNAPSHOT-jar-with-dependencies.jar;

CREATE EXTERNAL TABLE tweets_raw (
   id BIGINT,
   created_at STRING,
   source STRING,
   favorited BOOLEAN,
   retweet_count INT,
   retweeted_status STRUCT<
      text:STRING,
      user:STRUCT<screen_name:STRING,name:STRING>>,
   entities STRUCT<
      urls:ARRAY<STRUCT<expanded_url:STRING>>,
      user_mentions:ARRAY<STRUCT<screen_name:STRING,name:STRING>>,
      hashtags:ARRAY<STRUCT<text:STRING>>>,
   text STRING,
   user STRUCT<
      screen_name:STRING,
      name:STRING,
      friends_count:INT,
      followers_count:INT,
      statuses_count:INT,
      verified:BOOLEAN,
      utc_offset:STRING, -- was INT but nulls are strings
      time_zone:STRING>,
   in_reply_to_screen_name STRING
)
PARTITIONED BY (year INT, month INT, day INT, hour INT)

ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'  
LOCATION '/data/customer/tweets/landing';

ALTER TABLE tweets_raw ADD  PARTITION (year=2013,month=05,day=02,hour=15)  PARTITION (year=2013,month=05,day=02,hour=16) PARTITION (year=2013,month=05,day=02,hour=17) PARTITION (year=2013,month=05,day=02,hour=18) PARTITION (year=2013,month=05,day=02,hour=19) PARTITION (year=2013,month=05,day=02,hour=20) PARTITION (year=2013,month=05,day=02,hour=21) PARTITION (year=2013,month=05,day=02,hour=22) PARTITION (year=2013,month=05,day=02,hour=23)
PARTITION (year=2013,month=05,day=03,hour=01) 
PARTITION (year=2013,month=05,day=03,hour=02) 
PARTITION (year=2013,month=05,day=03,hour=03) 
PARTITION (year=2013,month=05,day=03,hour=04) 
PARTITION (year=2013,month=05,day=03,hour=05) 
PARTITION (year=2013,month=05,day=03,hour=06) 
PARTITION (year=2013,month=05,day=03,hour=07) 
PARTITION (year=2013,month=05,day=03,hour=08) 
PARTITION (year=2013,month=05,day=03,hour=09) 
PARTITION (year=2013,month=05,day=03,hour=10) 
PARTITION (year=2013,month=05,day=03,hour=11) 
PARTITION (year=2013,month=05,day=03,hour=12) 
PARTITION (year=2013,month=05,day=03,hour=13) 
PARTITION (year=2013,month=05,day=03,hour=14) 
PARTITION (year=2013,month=05,day=03,hour=15) 
PARTITION (year=2013,month=05,day=03,hour=16) 
PARTITION (year=2013,month=05,day=03,hour=17) 
PARTITION (year=2013,month=05,day=03,hour=18) 
PARTITION (year=2013,month=05,day=03,hour=19) 
PARTITION (year=2013,month=05,day=03,hour=20) 
PARTITION (year=2013,month=05,day=03,hour=21) 
PARTITION (year=2013,month=05,day=03,hour=22) 
PARTITION (year=2013,month=05,day=03,hour=23) 
PARTITION (year=2013,month=05,day=04,hour=01) 
PARTITION (year=2013,month=05,day=04,hour=02) 
PARTITION (year=2013,month=05,day=04,hour=03) 
PARTITION (year=2013,month=05,day=04,hour=04) 
PARTITION (year=2013,month=05,day=04,hour=05) 
PARTITION (year=2013,month=05,day=04,hour=06) 
PARTITION (year=2013,month=05,day=04,hour=07) 
PARTITION (year=2013,month=05,day=04,hour=08) 
PARTITION (year=2013,month=05,day=04,hour=09) 
PARTITION (year=2013,month=05,day=04,hour=10) 
PARTITION (year=2013,month=05,day=04,hour=11) 
PARTITION (year=2013,month=05,day=04,hour=12) 
PARTITION (year=2013,month=05,day=04,hour=13) 
PARTITION (year=2013,month=05,day=04,hour=14) 
PARTITION (year=2013,month=05,day=04,hour=15) 
PARTITION (year=2013,month=05,day=04,hour=16) 
PARTITION (year=2013,month=05,day=04,hour=17) 
PARTITION (year=2013,month=05,day=04,hour=18) 
PARTITION (year=2013,month=05,day=04,hour=19) 
PARTITION (year=2013,month=05,day=04,hour=20) 
PARTITION (year=2013,month=05,day=04,hour=21) 
PARTITION (year=2013,month=05,day=04,hour=22) 
PARTITION (year=2013,month=05,day=04,hour=23) 
PARTITION (year=2013,month=05,day=05,hour=01) 
PARTITION (year=2013,month=05,day=05,hour=02) 
PARTITION (year=2013,month=05,day=05,hour=03) 
PARTITION (year=2013,month=05,day=05,hour=04) 
PARTITION (year=2013,month=05,day=05,hour=05) 
PARTITION (year=2013,month=05,day=05,hour=06) 
PARTITION (year=2013,month=05,day=05,hour=07) 
PARTITION (year=2013,month=05,day=05,hour=08) 
PARTITION (year=2013,month=05,day=05,hour=09) 
PARTITION (year=2013,month=05,day=05,hour=10) 
PARTITION (year=2013,month=05,day=05,hour=11) 
PARTITION (year=2013,month=05,day=05,hour=12) 
PARTITION (year=2013,month=05,day=05,hour=13) 
PARTITION (year=2013,month=05,day=05,hour=14) 
PARTITION (year=2013,month=05,day=05,hour=15) 
PARTITION (year=2013,month=05,day=05,hour=16) 
PARTITION (year=2013,month=05,day=05,hour=17) 
PARTITION (year=2013,month=05,day=05,hour=18) 
PARTITION (year=2013,month=05,day=05,hour=19) 
PARTITION (year=2013,month=05,day=05,hour=20) 
PARTITION (year=2013,month=05,day=05,hour=21) 
PARTITION (year=2013,month=05,day=05,hour=22) 
PARTITION (year=2013,month=05,day=05,hour=23) 
PARTITION (year=2013,month=05,day=06,hour=01) 
PARTITION (year=2013,month=05,day=06,hour=02) 
PARTITION (year=2013,month=05,day=06,hour=03) 
PARTITION (year=2013,month=05,day=06,hour=04) 
PARTITION (year=2013,month=05,day=06,hour=05) 
PARTITION (year=2013,month=05,day=06,hour=06) 
PARTITION (year=2013,month=05,day=06,hour=07) 
PARTITION (year=2013,month=05,day=06,hour=08) 
PARTITION (year=2013,month=05,day=06,hour=09) 
PARTITION (year=2013,month=05,day=06,hour=10) 
PARTITION (year=2013,month=05,day=06,hour=11) 
PARTITION (year=2013,month=05,day=06,hour=12) 
PARTITION (year=2013,month=05,day=06,hour=13) 
PARTITION (year=2013,month=05,day=06,hour=14) 
PARTITION (year=2013,month=05,day=06,hour=15) 
PARTITION (year=2013,month=05,day=06,hour=16) 
PARTITION (year=2013,month=05,day=06,hour=17) 
PARTITION (year=2013,month=05,day=06,hour=18) 
PARTITION (year=2013,month=05,day=06,hour=19) 
PARTITION (year=2013,month=05,day=06,hour=20) 
PARTITION (year=2013,month=05,day=06,hour=21) 
PARTITION (year=2013,month=05,day=06,hour=22) 
PARTITION (year=2013,month=05,day=06,hour=23) 
PARTITION (year=2013,month=05,day=07,hour=01) 
PARTITION (year=2013,month=05,day=07,hour=02) 
PARTITION (year=2013,month=05,day=07,hour=03) 
PARTITION (year=2013,month=05,day=07,hour=04) 
PARTITION (year=2013,month=05,day=07,hour=05) 
PARTITION (year=2013,month=05,day=07,hour=06) 
PARTITION (year=2013,month=05,day=07,hour=07) 
PARTITION (year=2013,month=05,day=07,hour=08) 
PARTITION (year=2013,month=05,day=07,hour=09) 
PARTITION (year=2013,month=05,day=07,hour=10) 
PARTITION (year=2013,month=05,day=07,hour=11) 
PARTITION (year=2013,month=05,day=07,hour=12) 
PARTITION (year=2013,month=05,day=07,hour=13) 
PARTITION (year=2013,month=05,day=07,hour=14) 
PARTITION (year=2013,month=05,day=07,hour=15) 
PARTITION (year=2013,month=05,day=07,hour=16) 
PARTITION (year=2013,month=05,day=07,hour=17) 
PARTITION (year=2013,month=05,day=07,hour=18) 
PARTITION (year=2013,month=05,day=07,hour=19) 
PARTITION (year=2013,month=05,day=07,hour=20) 
PARTITION (year=2013,month=05,day=07,hour=21) 
PARTITION (year=2013,month=05,day=07,hour=22) 
PARTITION (year=2013,month=05,day=07,hour=23)
PARTITION (year=2013,month=05,day=08,hour=00)PARTITION (year=2013,month=05,day=08,hour=01)PARTITION (year=2013,month=05,day=08,hour=02)PARTITION (year=2013,month=05,day=08,hour=03)PARTITION (year=2013,month=05,day=08,hour=04)PARTITION (year=2013,month=05,day=08,hour=05)PARTITION (year=2013,month=05,day=08,hour=06)PARTITION (year=2013,month=05,day=08,hour=07)PARTITION (year=2013,month=05,day=08,hour=08)PARTITION (year=2013,month=05,day=08,hour=09)PARTITION (year=2013,month=05,day=08,hour=10)PARTITION (year=2013,month=05,day=08,hour=11)
;
 
