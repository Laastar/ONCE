' ********** Copyright 2017 Roku Corp.  All Rights Reserved. **********

sub GetContent()
    url = CreateObject("roUrlTransfer")
    'url.SetUrl("https://canaloncetv.s3.amazonaws.com/REST/data/mdb/carouselesapp.json")
    url.SetUrl("https://canaloncetv.s3.amazonaws.com/REST/data/mdb/vod_categoria.json")
    url.SetCertificatesFile("common:/certs/ca-bundle.crt")
    url.InitClientCertificates()
    feedos = url.GetToString()
    'this is for a sample, usually feed is retrieved from url using roUrlTransfer
    'feed = ReadAsciiFile("pkg:/feed/feed.json")
    sleep(500)
    
    json = ParseJson(feedos)
    rootNodeArray = ParseJsonToNodeArray(json)
    m.top.content.AppendChildren(rootNodeArray)
end sub

Function GetContentEpisodes(slug as String) as Object
    url = CreateObject("roUrlTransfer")
    print "https://canaloncetv.s3.amazonaws.com/REST/data/mdb/episodes/desktop/" + slug + ".json"
    url.SetUrl("https://canaloncetv.s3.amazonaws.com/REST/data/mdb/episodes/desktop/" + slug + ".json")
    url.SetCertificatesFile("common:/certs/ca-bundle.crt")
    url.InitClientCertificates()
    feedos = url.GetToString()
    
    sleep(500)

    json = ParseJson(feedos)
    return json
End Function


Function ParseJsonToNodeArray(jsonAA as Object) as Object
    if jsonAA = invalid then return []
    resultNodeArray = []

    'jsonAA = jsonAA[0]

    urlChannels = CreateObject("roUrlTransfer")
    urlChannels.SetUrl("https://canaloncetv.s3.amazonaws.com/REST/data/mdb/channels_roku.json")
    urlChannels.SetCertificatesFile("common:/certs/ca-bundle.crt")
    urlChannels.InitClientCertificates()
    channelsFeed = url.GetToString()
    sleep(500)
    jsonChannels = ParseJson(channelsFeed)

    for each programa in jsonAA
        'print jsonAA[programa]
        'print programa
        urlEpisodios = CreateObject("roUrlTransfer")
        urlEpisodios.SetUrl("https://canaloncetv.s3.amazonaws.com/REST/data/mdb/" + jsonAA[slugc] + ".json")
        urlEpisodios.SetCertificatesFile("common:/certs/ca-bundle.crt")
        urlEpisodios.InitClientCertificates()
        episodesFeed = url.GetToString()
        sleep(500)
        jsonEpisodes = ParseJson(episodesFeed)

        itemsNodeArray = []
        itemNode = ParseMediaItemToNodeTwo(programa, jsonEpisodes)
        itemsNodeArray.Push(itemNode)
        rowNode = Utils_AAToContentNode({
            title : program.name
        })
        rowNode.AppendChildren(itemsNodeArray)
        resultNodeArray.Push(rowNode)
    end for

    'for each fieldInJsonAA in jsonAA
        'print fieldInJsonAA
        'print fieldInJsonAA.carousel
        'print fieldInJsonAA.carousel
        'print fieldInJsonAA.carousel.textos
        'print fieldInJsonAA.carousel.textos[0]
        'print fieldInJsonAA.carousel.textos[0].texto
        ' Assigning fields that apply to both movies and series
        'print fieldInJsonAA.carousel.textos[0].texto
    '    if fieldInJsonAA.carousel.textos[0].texto <> invalid
    '        if fieldInJsonAA.carousel.textos[0].texto <> "CATEGORÍAS"
                'print fieldInJsonAA.carousel.textos[0].texto
    '            mediaItemsArray = fieldInJsonAA.carousel.carousel
    '            itemsNodeArray = []
    '            for each mediaItem in mediaItemsArray
                    'print mediaItem
    '                itemNode = ParseMediaItemToNode(mediaItem, "fieldInJsonAA")
    '                itemsNodeArray.Push(itemNode)
    '            end for
    '            rowNode = Utils_AAToContentNode({
    '                    title : fieldInJsonAA.carousel.textos[0].texto
    '                })
    '            rowNode.AppendChildren(itemsNodeArray)
    '            resultNodeArray.Push(rowNode)
    '        end if
    '    end if
    'end for
    print "Terminado"
    return resultNodeArray
End Function

Function ParseSearchItemToNode(programa as Object, titulo as String) as Object
    itemNode = Utils_AAToContentNode({
        '"id"    : mediaItem.id
        "title"    : "Buscar"
        '"hdPosterUrl" : "https://canalonce.mx/REST/data/normal/" + mediaItem.imageN
        '"Description" : mediaItem.description
        "Description": "Testing"
        '"Categories" : mediaItem.genres[0]
    })

    return itemNode
ENd Function

Function ParseMediaItemToNodeTwo(programa as Object, episodios as Object) as Object
    itemNode = Utils_AAToContentNode({
        '"id"    : mediaItem.id
        "title"    : pograma.name
        "hdPosterUrl" : "https://canalonce.mx/REST/data/normal/" + mediaItem.imageN
        "Description" : pograma.description
        '"Categories" : mediaItem.genres[0]
    })

    seasonArray = []
    for each season in programa
        episodeArray = []
        for each episodio in season
            episodeNode = Utils_AAToContentNode(episodio)
            Utils_forceSetFields(episodeNode, {
                "url" : episodio.vda
                '"url": "https://vivo.canaloncelive.tv/oncedos/ngrp:pruebachunks_all/playlist.m3u8"
                "title" : episodio.title
                '"hdPosterUrl" : episodio.thumbnail
                "Description" : episodio.description
            })
            episodeArray.Push(episodeNode)
        end for
        seasonArray.Push(episodeArray)
    end for

    Utils_forceSetFields(itemNode, {
        "seasons" : seasonArray
    })

    return itemNode
ENd Function


Function ParseMediaItemToNode(mediaItem as Object, mediaType as String) as Object

    print mediaItem.name
    itemNode = Utils_AAToContentNode({
            '"id"    : mediaItem.id
            "title"    : mediaItem.name
            "hdPosterUrl" : "https://canalonce.mx/REST/data/normal/" + mediaItem.imageN
            "Description" : mediaItem.description
            '"Categories" : mediaItem.genres[0]
        })

    if mediaItem = invalid then
        return itemNode
    end if

    episodios = GetContentEpisodes(mediaItem.slug)
    'print episodios
    'kin no existe
    if episodios = invalid then
        return itemNode
    end if

    'print episodios.count()
    maximo = episodios.count()
    seasonArray = []

    'Assign series specific fields
    'seasons = mediaItem.seasonn
    'seasonArray = []
    'for each season in seasons
    '    episodeArray = []
    '    for each episode in episodes
    '        episodeNode = Utils_AAToContentNode(episode)
    '        Utils_forceSetFields(episodeNode, {
    '            "url" : "https://d2mqwgsb5fhf0p.cloudfront.net/done_6f27343820/done_6f27343820.m3u"
    '            "title" : episode.title
    '            '"hdPosterUrl" : episode.thumbnail
    '            "Description" : episode.description
    '        })
    '        episodeArray.Push(episodeNode)
    '    end for
    '    seasonArray.Push(episodeArray)
    'end for
    'Utils_forceSetFields(itemNode, {
    '    "seasons" : seasonArray
    '})

    for x = 1 to maximo
        episodeArray = []
        for each episodio in episodios
            if episodio.title <> invalid AND episodio.seasonn <> invalid
                if episodio.seasonn.toInt() = x
                    episodeNode = Utils_AAToContentNode(episodio)
                    Utils_forceSetFields(episodeNode, {
                        '"url" : GetVideoUrl(episode)
                        "url": "https://vivo.canaloncelive.tv/oncedos/ngrp:pruebachunks_all/playlist.m3u8"
                        '"title" : episodio.title
                        "title": "Testing"
                        '"hdPosterUrl" : episode.thumbnail
                        "Description" : episodio.description
                    })
                    episodeArray.Push(episodeNode)
                end if
            end if
        end for
        'print episodeArray.count()
        if episodeArray.count() <> 0
            seasonArray.Push(episodeArray)
        else 
            x = maximo
        end if
    end for
    Utils_forceSetFields(itemNode, {
        "seasons" : seasonArray
    })
    

    ' Assign series specific fields
    'seasons = mediaItem.seasonn
    'seasonArray = []
    'for each season in seasons
    '    episodeArray = []
    '    episodes = season.lookup("episodes")
    '    for each episode in episodes
    '        episodeNode = Utils_AAToContentNode(episode)
    '        Utils_forceSetFields(episodeNode, {
    '            "url" : GetVideoUrl(episode)
    '            "title" : episode.title
    '            "hdPosterUrl" : episode.thumbnail
    '            "Description" : episode.shortDescription
    '        })
    '        episodeArray.Push(episodeNode)
    '    end for
    '    seasonArray.Push(episodeArray)
    'end for
    'Utils_forceSetFields(itemNode, {
    '        "seasons" : seasonArray
    '    })
    
    return itemNode
End Function

Function GetVideoUrl(mediaItem) as String
    content = mediaItem.Lookup("content")
    if content = invalid then
        return ""
    end if

    videos = content.Lookup("videos")
    if videos = invalid then
        return ""
    end if

    entry = videos.GetEntry(0)
    if entry = invalid then
        return ""
    end if

    url = entry.lookup("url")
    if url = invalid then
        return ""
    end if

    return url
End Function
