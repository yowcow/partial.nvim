<?php

$sql = 'select
a, count(1)
from b where
c=  1
group by a order by a';

$xml = '<VAST><Ad><Wrapper><VASTAdTagURI>http://example.com/</VASTAdTagURI>
</Wrapper></Ad>
</VAST>';

$json = '{"id":123,
"name":"yowcow"}';
