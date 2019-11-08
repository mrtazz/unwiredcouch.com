#!/usr/bin/env awk

BEGIN{ FS="|"; now=gensub(/00$/, ":00", "g",strftime("%Y-%m-%dT%T%z",systime()));
    printf("<?xml version=\"1.0\" encoding=\"utf-8\"?> \n\
    <feed xmlns=\"http://www.w3.org/2005/Atom\"> \n\
    \n\
    <title>unwiredcouch.com</title> \n\
    <subtitle>unwiredcouch.com</subtitle> \n\
    <link href=\"https://unwiredcouch.com/atom.xml\" rel=\"self\" /> \n\
    <link href=\"https://unwiredcouch.com/\" /> \n\
    <id>https://unwiredcouch.com/</id> \n\
    <updated>%s</updated> \n\
    <author> \n\
      <name>Daniel</name> \n\
      <email>d@unwiredcouch.com</email> \n\
    </author>", now)}

{ postdate=gensub(/00$/, ":00", "g",strftime("%Y-%m-%dT%T%z",mktime($1" 00 00 00")));
  printf("<entry> \n\
          <title>%s</title> \n\
          <link href=\"https://unwiredcouch.com%s\" /> \n\
              <id>https://unwiredcouch.com%s</id> \n\
          <updated>%s</updated> \n\
          <content type=\"html\">", $3, $2, $2, postdate );
        system("pandoc "$4" \
                --from=markdown_github-hard_line_breaks+yaml_metadata_block \
                --email-obfuscation=none --to=html \
                | sed 's/&/\\&amp;/g; s/</\\&lt;/g; s/>/\\&gt;/g; s/\"/\\&quot;/g; s/'\"'\"'/\\&#39;/g'");
        print "</content>\n</entry>"  }

END{ print "</feed>" }
