<?php

    header("content-type: text/xml");
?>
<Response>
    <Say> Hello. </Say>
    <Gather numDigits="1" method="POST">
       <Say>For English, press 1. For Hindi, press 2. For French, press 3.</Say>
    </Gather>
</Response>
