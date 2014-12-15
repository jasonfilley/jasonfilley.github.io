---
layout: post
title: PHP SOAP Handling of SAP Table Reads
permalink: 2012/03/11/php-soap-handling-of-sap-table-reads/
---

Handle tables returned from SAP, with PHP+SOAP.

![SAP tables with SOAP]({{ site.url }}/images/sap_php_table.jpg)

<!--excerpt-->

Note that AtpTable is listed as input (non-optional). Just pass it an empty string. For the output, you have to handle 3 cases: empty, 1 result (returns a single object), more than 1 result (returns an array). Make sure SOAP_SINGLE_ELEMENT_ARRAYS is set, which returns an array of 1 item when only 1 item exists (PHP considers that a feature, not a bug). Then you just test that the array exists (isset).

{% highlight php %}

<?php
$SOAP_OPTS = array( 'login' => '<THEACCOUNT>',
                    'password' => '<THEPASSWORD>',
                    'features' => SOAP_SINGLE_ELEMENT_ARRAYS);
$WSDL = 'http://sap.corp.example.com:8000/sap/bc/srt/wsdl/bndg_BLAHBLAHBLAH/wsdl11/allinone/standard/document?sap-client=100';
$client = new SoapClient($WSDL,$SOAP_OPTS);
$params = array(
    'AtpTable' => '',
    'Branch' => '1',
    'CheckRule' => 'A',
    'GetRows' => '100',
    'IncludeUnsavSo' => 'X',
    'StartMaterial' => '12345',
    'Sloc' => '0001'
);

try
{
    $result = $client->ZfmGetAtpTest($params);
}

catch (SoapFault $exception)
{
    print '***Caught Exception***\n';
    print_r($exception);
    print '***END Exception***\n';
    die();
}

#print_r($result);
if (isset($result->AtpTable->item)) {
    foreach ($result->AtpTable->item as $row) {
        print '$row->Material\t$row->Branch\t$row->AtpQty\n';
    }
}
?>
{% endhighlight %}


