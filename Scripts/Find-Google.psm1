function Find-Google {
    param (
        $Query,
        $Lang = "ru",
        $Num = 10,
        $Start = 0,
        $Key = "<TOKEN_API>",
        $cx = "35c78340f49eb474a"
    )
    $query
    $response = Invoke-RestMethod "https://www.googleapis.com/customsearch/v1?q=$Query&key=$Key&cx=$cx&lr=lang_$Lang&num=$Num&$start=$Start"
    $response.items | Select-Object title,snippet,displayLink,link | Format-List
}

# Find-Google "как создать бота discord"
# Find-Google "как создать бота discord" -Lang ru -Num 10 -Start 9