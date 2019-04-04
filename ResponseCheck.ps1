$url = 'http://localhost:5000'
$req = [system.Net.WebRequest]::Create($url)

try {
    $res = $req.GetResponse()
} 
catch [System.Net.WebException] {
    $res = $_.Exception.Response
}

$res.StatusCode

[int]$res.StatusCode