//
//  TMDBGeneratedAPISuite.swift
//  MovieAppTests
//
//  Generated from TMDB OpenAPI v3. Do not edit by hand.
//

import Foundation
import Testing

@testable import MovieApp

@Suite("TMDBGeneratedAPI")
struct TMDBGeneratedAPISuite {
    @Test("AuthenticationValidateKey endpoint")
    func tmdbAuthenticationValidateKeyBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbAuthenticationValidateKey()

        #expect(endpoint.path == "/authentication")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("AccountDetails endpoint")
    func tmdbAccountDetailsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbAccountDetails(accountId: 1, sessionId: "value")

        #expect(endpoint.path == "/account/1")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("AccountAddFavorite endpoint")
    func tmdbAccountAddFavoriteBuildsEndpoint() throws {
        let endpoint = try Endpoint.tmdbAccountAddFavorite(accountId: 1, sessionId: "value", body: TMDBAccountAddFavoriteRequestDTO())

        #expect(endpoint.path == "/account/1/favorite")
        #expect(endpoint.method == .post)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body != nil)
    }

    @Test("AccountAddToWatchlist endpoint")
    func tmdbAccountAddToWatchlistBuildsEndpoint() throws {
        let endpoint = try Endpoint.tmdbAccountAddToWatchlist(accountId: 1, sessionId: "value", body: TMDBAccountAddToWatchlistRequestDTO())

        #expect(endpoint.path == "/account/1/watchlist")
        #expect(endpoint.method == .post)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body != nil)
    }

    @Test("AccountGetFavorites endpoint")
    func tmdbAccountGetFavoritesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbAccountGetFavorites(accountId: 1, language: "value", page: 1, sessionId: "value", sortBy: "value")

        #expect(endpoint.path == "/account/1/favorite/movies")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("AccountFavoriteTv endpoint")
    func tmdbAccountFavoriteTvBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbAccountFavoriteTv(accountId: 1, language: "value", page: 1, sessionId: "value", sortBy: "value")

        #expect(endpoint.path == "/account/1/favorite/tv")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("AccountLists endpoint")
    func tmdbAccountListsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbAccountLists(accountId: 1, page: 1, sessionId: "value")

        #expect(endpoint.path == "/account/1/lists")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("AccountRatedMovies endpoint")
    func tmdbAccountRatedMoviesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbAccountRatedMovies(accountId: 1, language: "value", page: 1, sessionId: "value", sortBy: "value")

        #expect(endpoint.path == "/account/1/rated/movies")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("AccountRatedTv endpoint")
    func tmdbAccountRatedTvBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbAccountRatedTv(accountId: 1, language: "value", page: 1, sessionId: "value", sortBy: "value")

        #expect(endpoint.path == "/account/1/rated/tv")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("AccountRatedTvEpisodes endpoint")
    func tmdbAccountRatedTvEpisodesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbAccountRatedTvEpisodes(accountId: 1, language: "value", page: 1, sessionId: "value", sortBy: "value")

        #expect(endpoint.path == "/account/1/rated/tv/episodes")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("AccountWatchlistMovies endpoint")
    func tmdbAccountWatchlistMoviesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbAccountWatchlistMovies(accountId: 1, language: "value", page: 1, sessionId: "value", sortBy: "value")

        #expect(endpoint.path == "/account/1/watchlist/movies")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("AccountWatchlistTv endpoint")
    func tmdbAccountWatchlistTvBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbAccountWatchlistTv(accountId: 1, language: "value", page: 1, sessionId: "value", sortBy: "value")

        #expect(endpoint.path == "/account/1/watchlist/tv")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("AuthenticationCreateGuestSession endpoint")
    func tmdbAuthenticationCreateGuestSessionBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbAuthenticationCreateGuestSession()

        #expect(endpoint.path == "/authentication/guest_session/new")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("AuthenticationCreateRequestToken endpoint")
    func tmdbAuthenticationCreateRequestTokenBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbAuthenticationCreateRequestToken()

        #expect(endpoint.path == "/authentication/token/new")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("AuthenticationCreateSession endpoint")
    func tmdbAuthenticationCreateSessionBuildsEndpoint() throws {
        let endpoint = try Endpoint.tmdbAuthenticationCreateSession(body: TMDBAuthenticationCreateSessionRequestDTO())

        #expect(endpoint.path == "/authentication/session/new")
        #expect(endpoint.method == .post)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body != nil)
    }

    @Test("AuthenticationCreateSessionFromV4Token endpoint")
    func tmdbAuthenticationCreateSessionFromV4TokenBuildsEndpoint() throws {
        let endpoint = try Endpoint.tmdbAuthenticationCreateSessionFromV4Token(body: TMDBAuthenticationCreateSessionFromV4TokenRequestDTO())

        #expect(endpoint.path == "/authentication/session/convert/4")
        #expect(endpoint.method == .post)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body != nil)
    }

    @Test("AuthenticationCreateSessionFromLogin endpoint")
    func tmdbAuthenticationCreateSessionFromLoginBuildsEndpoint() throws {
        let endpoint = try Endpoint.tmdbAuthenticationCreateSessionFromLogin(body: TMDBAuthenticationCreateSessionFromLoginRequestDTO())

        #expect(endpoint.path == "/authentication/token/validate_with_login")
        #expect(endpoint.method == .post)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body != nil)
    }

    @Test("AuthenticationDeleteSession endpoint")
    func tmdbAuthenticationDeleteSessionBuildsEndpoint() throws {
        let endpoint = try Endpoint.tmdbAuthenticationDeleteSession(body: TMDBAuthenticationDeleteSessionRequestDTO())

        #expect(endpoint.path == "/authentication/session")
        #expect(endpoint.method == .delete)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body != nil)
    }

    @Test("CertificationMovieList endpoint")
    func tmdbCertificationMovieListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbCertificationMovieList()

        #expect(endpoint.path == "/certification/movie/list")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("CertificationsTvList endpoint")
    func tmdbCertificationsTvListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbCertificationsTvList()

        #expect(endpoint.path == "/certification/tv/list")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("ChangesMovieList endpoint")
    func tmdbChangesMovieListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbChangesMovieList(endDate: "value", page: 1, startDate: "value")

        #expect(endpoint.path == "/movie/changes")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("ChangesPeopleList endpoint")
    func tmdbChangesPeopleListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbChangesPeopleList(endDate: "value", page: 1, startDate: "value")

        #expect(endpoint.path == "/person/changes")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("ChangesTvList endpoint")
    func tmdbChangesTvListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbChangesTvList(endDate: "value", page: 1, startDate: "value")

        #expect(endpoint.path == "/tv/changes")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("CollectionDetails endpoint")
    func tmdbCollectionDetailsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbCollectionDetails(collectionId: 1, language: "value")

        #expect(endpoint.path == "/collection/1")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("CollectionImages endpoint")
    func tmdbCollectionImagesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbCollectionImages(collectionId: 1, includeImageLanguage: "value", language: "value")

        #expect(endpoint.path == "/collection/1/images")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("CollectionTranslations endpoint")
    func tmdbCollectionTranslationsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbCollectionTranslations(collectionId: 1)

        #expect(endpoint.path == "/collection/1/translations")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("CompanyDetails endpoint")
    func tmdbCompanyDetailsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbCompanyDetails(companyId: 1)

        #expect(endpoint.path == "/company/1")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("CompanyAlternativeNames endpoint")
    func tmdbCompanyAlternativeNamesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbCompanyAlternativeNames(companyId: 1)

        #expect(endpoint.path == "/company/1/alternative_names")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("CompanyImages endpoint")
    func tmdbCompanyImagesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbCompanyImages(companyId: 1)

        #expect(endpoint.path == "/company/1/images")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("ConfigurationDetails endpoint")
    func tmdbConfigurationDetailsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbConfigurationDetails()

        #expect(endpoint.path == "/configuration")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("ConfigurationCountries endpoint")
    func tmdbConfigurationCountriesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbConfigurationCountries(language: "value")

        #expect(endpoint.path == "/configuration/countries")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("ConfigurationJobs endpoint")
    func tmdbConfigurationJobsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbConfigurationJobs()

        #expect(endpoint.path == "/configuration/jobs")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("ConfigurationLanguages endpoint")
    func tmdbConfigurationLanguagesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbConfigurationLanguages()

        #expect(endpoint.path == "/configuration/languages")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("ConfigurationPrimaryTranslations endpoint")
    func tmdbConfigurationPrimaryTranslationsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbConfigurationPrimaryTranslations()

        #expect(endpoint.path == "/configuration/primary_translations")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("ConfigurationTimezones endpoint")
    func tmdbConfigurationTimezonesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbConfigurationTimezones()

        #expect(endpoint.path == "/configuration/timezones")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("CreditDetails endpoint")
    func tmdbCreditDetailsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbCreditDetails(creditId: "value", language: "value")

        #expect(endpoint.path == "/credit/value")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("DiscoverMovie endpoint")
    func tmdbDiscoverMovieBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbDiscoverMovie(certification: "value", certificationGte: "value", certificationLte: "value", certificationCountry: "value", includeAdult: true, includeVideo: true, language: "value", page: 1, primaryReleaseYear: 1, primaryReleaseDateGte: "value", primaryReleaseDateLte: "value", region: "value", releaseDateGte: "value", releaseDateLte: "value", sortBy: "value", voteAverageGte: 1.5, voteAverageLte: 1.5, voteCountGte: 1.5, voteCountLte: 1.5, watchRegion: "value", withCast: "value", withCompanies: "value", withCrew: "value", withGenres: "value", withKeywords: "value", withOriginCountry: "value", withOriginalLanguage: "value", withPeople: "value", withReleaseType: 1, withRuntimeGte: 1, withRuntimeLte: 1, withWatchMonetizationTypes: "value", withWatchProviders: "value", withoutCompanies: "value", withoutGenres: "value", withoutKeywords: "value", withoutWatchProviders: "value", year: 1)

        #expect(endpoint.path == "/discover/movie")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("DiscoverTv endpoint")
    func tmdbDiscoverTvBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbDiscoverTv(airDateGte: "value", airDateLte: "value", firstAirDateYear: 1, firstAirDateGte: "value", firstAirDateLte: "value", includeAdult: true, includeNullFirstAirDates: true, language: "value", page: 1, screenedTheatrically: true, sortBy: "value", timezone: "value", voteAverageGte: 1.5, voteAverageLte: 1.5, voteCountGte: 1.5, voteCountLte: 1.5, watchRegion: "value", withCompanies: "value", withGenres: "value", withKeywords: "value", withNetworks: 1, withOriginCountry: "value", withOriginalLanguage: "value", withRuntimeGte: 1, withRuntimeLte: 1, withStatus: "value", withWatchMonetizationTypes: "value", withWatchProviders: "value", withoutCompanies: "value", withoutGenres: "value", withoutKeywords: "value", withoutWatchProviders: "value", withType: "value")

        #expect(endpoint.path == "/discover/tv")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("FindById endpoint")
    func tmdbFindByIdBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbFindById(externalId: "value", externalSource: "value", language: "value")

        #expect(endpoint.path == "/find/value")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("GenreMovieList endpoint")
    func tmdbGenreMovieListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbGenreMovieList(language: "value")

        #expect(endpoint.path == "/genre/movie/list")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("GenreTvList endpoint")
    func tmdbGenreTvListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbGenreTvList(language: "value")

        #expect(endpoint.path == "/genre/tv/list")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("GuestSessionRatedMovies endpoint")
    func tmdbGuestSessionRatedMoviesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbGuestSessionRatedMovies(guestSessionId: "value", language: "value", page: 1, sortBy: "value")

        #expect(endpoint.path == "/guest_session/value/rated/movies")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("GuestSessionRatedTv endpoint")
    func tmdbGuestSessionRatedTvBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbGuestSessionRatedTv(guestSessionId: "value", language: "value", page: 1, sortBy: "value")

        #expect(endpoint.path == "/guest_session/value/rated/tv")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("GuestSessionRatedTvEpisodes endpoint")
    func tmdbGuestSessionRatedTvEpisodesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbGuestSessionRatedTvEpisodes(guestSessionId: "value", language: "value", page: 1, sortBy: "value")

        #expect(endpoint.path == "/guest_session/value/rated/tv/episodes")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("KeywordDetails endpoint")
    func tmdbKeywordDetailsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbKeywordDetails(keywordId: 1)

        #expect(endpoint.path == "/keyword/1")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("KeywordMovies endpoint")
    func tmdbKeywordMoviesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbKeywordMovies(keywordId: "value", includeAdult: true, language: "value", page: 1)

        #expect(endpoint.path == "/keyword/value/movies")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("ListAddMovie endpoint")
    func tmdbListAddMovieBuildsEndpoint() throws {
        let endpoint = try Endpoint.tmdbListAddMovie(listId: 1, sessionId: "value", body: TMDBListAddMovieRequestDTO())

        #expect(endpoint.path == "/list/1/add_item")
        #expect(endpoint.method == .post)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body != nil)
    }

    @Test("ListCheckItemStatus endpoint")
    func tmdbListCheckItemStatusBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbListCheckItemStatus(listId: 1, language: "value", movieId: 1)

        #expect(endpoint.path == "/list/1/item_status")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("ListClear endpoint")
    func tmdbListClearBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbListClear(listId: 1, sessionId: "value", confirm: true)

        #expect(endpoint.path == "/list/1/clear")
        #expect(endpoint.method == .post)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("ListCreate endpoint")
    func tmdbListCreateBuildsEndpoint() throws {
        let endpoint = try Endpoint.tmdbListCreate(sessionId: "value", body: TMDBListCreateRequestDTO())

        #expect(endpoint.path == "/list")
        #expect(endpoint.method == .post)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body != nil)
    }

    @Test("ListDelete endpoint")
    func tmdbListDeleteBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbListDelete(listId: 1, sessionId: "value")

        #expect(endpoint.path == "/list/1")
        #expect(endpoint.method == .delete)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("ListDetails endpoint")
    func tmdbListDetailsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbListDetails(listId: 1, language: "value", page: 1)

        #expect(endpoint.path == "/list/1")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("ListRemoveMovie endpoint")
    func tmdbListRemoveMovieBuildsEndpoint() throws {
        let endpoint = try Endpoint.tmdbListRemoveMovie(listId: 1, sessionId: "value", body: TMDBListRemoveMovieRequestDTO())

        #expect(endpoint.path == "/list/1/remove_item")
        #expect(endpoint.method == .post)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body != nil)
    }

    @Test("MovieNowPlayingList endpoint")
    func tmdbMovieNowPlayingListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieNowPlayingList(language: "value", page: 1, region: "value")

        #expect(endpoint.path == "/movie/now_playing")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("MoviePopularList endpoint")
    func tmdbMoviePopularListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMoviePopularList(language: "value", page: 1, region: "value")

        #expect(endpoint.path == "/movie/popular")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("MovieTopRatedList endpoint")
    func tmdbMovieTopRatedListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieTopRatedList(language: "value", page: 1, region: "value")

        #expect(endpoint.path == "/movie/top_rated")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("MovieUpcomingList endpoint")
    func tmdbMovieUpcomingListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieUpcomingList(language: "value", page: 1, region: "value")

        #expect(endpoint.path == "/movie/upcoming")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("MovieDetails endpoint")
    func tmdbMovieDetailsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieDetails(movieId: 1, appendToResponse: "value", language: "value")

        #expect(endpoint.path == "/movie/1")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("MovieAccountStates endpoint")
    func tmdbMovieAccountStatesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieAccountStates(movieId: 1, sessionId: "value", guestSessionId: "value")

        #expect(endpoint.path == "/movie/1/account_states")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("MovieAlternativeTitles endpoint")
    func tmdbMovieAlternativeTitlesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieAlternativeTitles(movieId: 1, country: "value")

        #expect(endpoint.path == "/movie/1/alternative_titles")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("MovieChanges endpoint")
    func tmdbMovieChangesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieChanges(movieId: 1, endDate: "value", page: 1, startDate: "value")

        #expect(endpoint.path == "/movie/1/changes")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("MovieCredits endpoint")
    func tmdbMovieCreditsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieCredits(movieId: 1, language: "value")

        #expect(endpoint.path == "/movie/1/credits")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("MovieExternalIds endpoint")
    func tmdbMovieExternalIdsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieExternalIds(movieId: 1)

        #expect(endpoint.path == "/movie/1/external_ids")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("MovieImages endpoint")
    func tmdbMovieImagesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieImages(movieId: 1, includeImageLanguage: "value", language: "value")

        #expect(endpoint.path == "/movie/1/images")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("MovieKeywords endpoint")
    func tmdbMovieKeywordsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieKeywords(movieId: "value")

        #expect(endpoint.path == "/movie/value/keywords")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("MovieLatestId endpoint")
    func tmdbMovieLatestIdBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieLatestId()

        #expect(endpoint.path == "/movie/latest")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("MovieLists endpoint")
    func tmdbMovieListsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieLists(movieId: 1, language: "value", page: 1)

        #expect(endpoint.path == "/movie/1/lists")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("MovieRecommendations endpoint")
    func tmdbMovieRecommendationsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieRecommendations(movieId: 1, language: "value", page: 1)

        #expect(endpoint.path == "/movie/1/recommendations")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("MovieReleaseDates endpoint")
    func tmdbMovieReleaseDatesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieReleaseDates(movieId: 1)

        #expect(endpoint.path == "/movie/1/release_dates")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("MovieReviews endpoint")
    func tmdbMovieReviewsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieReviews(movieId: 1, language: "value", page: 1)

        #expect(endpoint.path == "/movie/1/reviews")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("MovieSimilar endpoint")
    func tmdbMovieSimilarBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieSimilar(movieId: 1, language: "value", page: 1)

        #expect(endpoint.path == "/movie/1/similar")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("MovieTranslations endpoint")
    func tmdbMovieTranslationsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieTranslations(movieId: 1)

        #expect(endpoint.path == "/movie/1/translations")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("MovieVideos endpoint")
    func tmdbMovieVideosBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieVideos(movieId: 1, language: "value")

        #expect(endpoint.path == "/movie/1/videos")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("MovieWatchProviders endpoint")
    func tmdbMovieWatchProvidersBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieWatchProviders(movieId: 1)

        #expect(endpoint.path == "/movie/1/watch/providers")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("MovieAddRating endpoint")
    func tmdbMovieAddRatingBuildsEndpoint() throws {
        let endpoint = try Endpoint.tmdbMovieAddRating(movieId: 1, guestSessionId: "value", sessionId: "value", contentType: "value", body: TMDBMovieAddRatingRequestDTO())

        #expect(endpoint.path == "/movie/1/rating")
        #expect(endpoint.method == .post)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body != nil)
    }

    @Test("MovieDeleteRating endpoint")
    func tmdbMovieDeleteRatingBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbMovieDeleteRating(movieId: 1, contentType: "value", guestSessionId: "value", sessionId: "value")

        #expect(endpoint.path == "/movie/1/rating")
        #expect(endpoint.method == .delete)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("NetworkDetails endpoint")
    func tmdbNetworkDetailsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbNetworkDetails(networkId: 1)

        #expect(endpoint.path == "/network/1")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("DetailsCopy endpoint")
    func tmdbDetailsCopyBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbDetailsCopy(networkId: 1)

        #expect(endpoint.path == "/network/1/alternative_names")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("AlternativeNamesCopy endpoint")
    func tmdbAlternativeNamesCopyBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbAlternativeNamesCopy(networkId: 1)

        #expect(endpoint.path == "/network/1/images")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("PersonPopularList endpoint")
    func tmdbPersonPopularListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbPersonPopularList(language: "value", page: 1)

        #expect(endpoint.path == "/person/popular")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("PersonDetails endpoint")
    func tmdbPersonDetailsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbPersonDetails(personId: 1, appendToResponse: "value", language: "value")

        #expect(endpoint.path == "/person/1")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("PersonChanges endpoint")
    func tmdbPersonChangesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbPersonChanges(personId: 1, endDate: "value", page: 1, startDate: "value")

        #expect(endpoint.path == "/person/1/changes")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("PersonCombinedCredits endpoint")
    func tmdbPersonCombinedCreditsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbPersonCombinedCredits(personId: "value", language: "value")

        #expect(endpoint.path == "/person/value/combined_credits")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("PersonExternalIds endpoint")
    func tmdbPersonExternalIdsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbPersonExternalIds(personId: 1)

        #expect(endpoint.path == "/person/1/external_ids")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("PersonImages endpoint")
    func tmdbPersonImagesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbPersonImages(personId: 1)

        #expect(endpoint.path == "/person/1/images")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("PersonLatestId endpoint")
    func tmdbPersonLatestIdBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbPersonLatestId()

        #expect(endpoint.path == "/person/latest")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("PersonMovieCredits endpoint")
    func tmdbPersonMovieCreditsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbPersonMovieCredits(personId: 1, language: "value")

        #expect(endpoint.path == "/person/1/movie_credits")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("PersonTvCredits endpoint")
    func tmdbPersonTvCreditsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbPersonTvCredits(personId: 1, language: "value")

        #expect(endpoint.path == "/person/1/tv_credits")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("PersonTaggedImages endpoint")
    func tmdbPersonTaggedImagesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbPersonTaggedImages(personId: 1, page: 1)

        #expect(endpoint.path == "/person/1/tagged_images")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("Translations endpoint")
    func tmdbTranslationsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTranslations(personId: 1)

        #expect(endpoint.path == "/person/1/translations")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("ReviewDetails endpoint")
    func tmdbReviewDetailsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbReviewDetails(reviewId: "value")

        #expect(endpoint.path == "/review/value")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("SearchCollection endpoint")
    func tmdbSearchCollectionBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbSearchCollection(query: "value", includeAdult: true, language: "value", page: 1, region: "value")

        #expect(endpoint.path == "/search/collection")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("SearchCompany endpoint")
    func tmdbSearchCompanyBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbSearchCompany(query: "value", page: 1)

        #expect(endpoint.path == "/search/company")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("SearchKeyword endpoint")
    func tmdbSearchKeywordBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbSearchKeyword(query: "value", page: 1)

        #expect(endpoint.path == "/search/keyword")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("SearchMovie endpoint")
    func tmdbSearchMovieBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbSearchMovie(query: "value", includeAdult: true, language: "value", primaryReleaseYear: "value", page: 1, region: "value", year: "value")

        #expect(endpoint.path == "/search/movie")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("SearchMulti endpoint")
    func tmdbSearchMultiBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbSearchMulti(query: "value", includeAdult: true, language: "value", page: 1)

        #expect(endpoint.path == "/search/multi")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("SearchPerson endpoint")
    func tmdbSearchPersonBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbSearchPerson(query: "value", includeAdult: true, language: "value", page: 1)

        #expect(endpoint.path == "/search/person")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("SearchTv endpoint")
    func tmdbSearchTvBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbSearchTv(query: "value", firstAirDateYear: 1, includeAdult: true, language: "value", page: 1, year: 1)

        #expect(endpoint.path == "/search/tv")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TrendingAll endpoint")
    func tmdbTrendingAllBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTrendingAll(timeWindow: "value", language: "value")

        #expect(endpoint.path == "/trending/all/value")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TrendingMovies endpoint")
    func tmdbTrendingMoviesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTrendingMovies(timeWindow: "value", language: "value")

        #expect(endpoint.path == "/trending/movie/value")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TrendingPeople endpoint")
    func tmdbTrendingPeopleBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTrendingPeople(timeWindow: "value", language: "value")

        #expect(endpoint.path == "/trending/person/value")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TrendingTv endpoint")
    func tmdbTrendingTvBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTrendingTv(timeWindow: "value", language: "value")

        #expect(endpoint.path == "/trending/tv/value")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesAiringTodayList endpoint")
    func tmdbTvSeriesAiringTodayListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesAiringTodayList(language: "value", page: 1, timezone: "value")

        #expect(endpoint.path == "/tv/airing_today")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesOnTheAirList endpoint")
    func tmdbTvSeriesOnTheAirListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesOnTheAirList(language: "value", page: 1, timezone: "value")

        #expect(endpoint.path == "/tv/on_the_air")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesPopularList endpoint")
    func tmdbTvSeriesPopularListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesPopularList(language: "value", page: 1)

        #expect(endpoint.path == "/tv/popular")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesTopRatedList endpoint")
    func tmdbTvSeriesTopRatedListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesTopRatedList(language: "value", page: 1)

        #expect(endpoint.path == "/tv/top_rated")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesDetails endpoint")
    func tmdbTvSeriesDetailsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesDetails(seriesId: 1, appendToResponse: "value", language: "value")

        #expect(endpoint.path == "/tv/1")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesAccountStates endpoint")
    func tmdbTvSeriesAccountStatesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesAccountStates(seriesId: 1, sessionId: "value", guestSessionId: "value")

        #expect(endpoint.path == "/tv/1/account_states")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesAggregateCredits endpoint")
    func tmdbTvSeriesAggregateCreditsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesAggregateCredits(seriesId: 1, language: "value")

        #expect(endpoint.path == "/tv/1/aggregate_credits")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesAlternativeTitles endpoint")
    func tmdbTvSeriesAlternativeTitlesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesAlternativeTitles(seriesId: 1)

        #expect(endpoint.path == "/tv/1/alternative_titles")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesChanges endpoint")
    func tmdbTvSeriesChangesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesChanges(seriesId: 1, endDate: "value", page: 1, startDate: "value")

        #expect(endpoint.path == "/tv/1/changes")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesContentRatings endpoint")
    func tmdbTvSeriesContentRatingsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesContentRatings(seriesId: 1)

        #expect(endpoint.path == "/tv/1/content_ratings")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesCredits endpoint")
    func tmdbTvSeriesCreditsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesCredits(seriesId: 1, language: "value")

        #expect(endpoint.path == "/tv/1/credits")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesEpisodeGroups endpoint")
    func tmdbTvSeriesEpisodeGroupsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesEpisodeGroups(seriesId: 1)

        #expect(endpoint.path == "/tv/1/episode_groups")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesExternalIds endpoint")
    func tmdbTvSeriesExternalIdsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesExternalIds(seriesId: 1)

        #expect(endpoint.path == "/tv/1/external_ids")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesImages endpoint")
    func tmdbTvSeriesImagesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesImages(seriesId: 1, includeImageLanguage: "value", language: "value")

        #expect(endpoint.path == "/tv/1/images")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesKeywords endpoint")
    func tmdbTvSeriesKeywordsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesKeywords(seriesId: 1)

        #expect(endpoint.path == "/tv/1/keywords")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesLatestId endpoint")
    func tmdbTvSeriesLatestIdBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesLatestId()

        #expect(endpoint.path == "/tv/latest")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("ListsCopy endpoint")
    func tmdbListsCopyBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbListsCopy(seriesId: 1, language: "value", page: 1)

        #expect(endpoint.path == "/tv/1/lists")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesRecommendations endpoint")
    func tmdbTvSeriesRecommendationsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesRecommendations(seriesId: 1, language: "value", page: 1)

        #expect(endpoint.path == "/tv/1/recommendations")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesReviews endpoint")
    func tmdbTvSeriesReviewsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesReviews(seriesId: 1, language: "value", page: 1)

        #expect(endpoint.path == "/tv/1/reviews")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesScreenedTheatrically endpoint")
    func tmdbTvSeriesScreenedTheatricallyBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesScreenedTheatrically(seriesId: 1)

        #expect(endpoint.path == "/tv/1/screened_theatrically")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesSimilar endpoint")
    func tmdbTvSeriesSimilarBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesSimilar(seriesId: "value", language: "value", page: 1)

        #expect(endpoint.path == "/tv/value/similar")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesTranslations endpoint")
    func tmdbTvSeriesTranslationsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesTranslations(seriesId: 1)

        #expect(endpoint.path == "/tv/1/translations")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesVideos endpoint")
    func tmdbTvSeriesVideosBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesVideos(seriesId: 1, includeVideoLanguage: "value", language: "value")

        #expect(endpoint.path == "/tv/1/videos")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesWatchProviders endpoint")
    func tmdbTvSeriesWatchProvidersBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesWatchProviders(seriesId: 1)

        #expect(endpoint.path == "/tv/1/watch/providers")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeriesAddRating endpoint")
    func tmdbTvSeriesAddRatingBuildsEndpoint() throws {
        let endpoint = try Endpoint.tmdbTvSeriesAddRating(seriesId: 1, guestSessionId: "value", sessionId: "value", contentType: "value", body: TMDBTvSeriesAddRatingRequestDTO())

        #expect(endpoint.path == "/tv/1/rating")
        #expect(endpoint.method == .post)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body != nil)
    }

    @Test("TvSeriesDeleteRating endpoint")
    func tmdbTvSeriesDeleteRatingBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeriesDeleteRating(seriesId: 1, contentType: "value", guestSessionId: "value", sessionId: "value")

        #expect(endpoint.path == "/tv/1/rating")
        #expect(endpoint.method == .delete)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeasonDetails endpoint")
    func tmdbTvSeasonDetailsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeasonDetails(seriesId: 1, seasonNumber: 1, appendToResponse: "value", language: "value")

        #expect(endpoint.path == "/tv/1/season/1")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeasonAccountStates endpoint")
    func tmdbTvSeasonAccountStatesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeasonAccountStates(seriesId: 1, sessionId: "value", guestSessionId: "value", seasonNumber: 1)

        #expect(endpoint.path == "/tv/1/season/1/account_states")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeasonAggregateCredits endpoint")
    func tmdbTvSeasonAggregateCreditsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeasonAggregateCredits(seriesId: 1, language: "value", seasonNumber: 1)

        #expect(endpoint.path == "/tv/1/season/1/aggregate_credits")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeasonChangesById endpoint")
    func tmdbTvSeasonChangesByIdBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeasonChangesById(endDate: "value", page: 1, startDate: "value", seasonId: 1)

        #expect(endpoint.path == "/tv/season/1/changes")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeasonCredits endpoint")
    func tmdbTvSeasonCreditsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeasonCredits(seriesId: 1, seasonNumber: 1, language: "value")

        #expect(endpoint.path == "/tv/1/season/1/credits")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeasonExternalIds endpoint")
    func tmdbTvSeasonExternalIdsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeasonExternalIds(seriesId: 1, seasonNumber: 1)

        #expect(endpoint.path == "/tv/1/season/1/external_ids")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeasonImages endpoint")
    func tmdbTvSeasonImagesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeasonImages(seriesId: 1, includeImageLanguage: "value", language: "value", seasonNumber: 1)

        #expect(endpoint.path == "/tv/1/season/1/images")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeasonTranslations endpoint")
    func tmdbTvSeasonTranslationsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeasonTranslations(seriesId: 1, seasonNumber: 1)

        #expect(endpoint.path == "/tv/1/season/1/translations")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeasonVideos endpoint")
    func tmdbTvSeasonVideosBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeasonVideos(seriesId: 1, includeVideoLanguage: "value", language: "value", seasonNumber: 1)

        #expect(endpoint.path == "/tv/1/season/1/videos")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvSeasonWatchProviders endpoint")
    func tmdbTvSeasonWatchProvidersBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvSeasonWatchProviders(seriesId: 1, language: "value", seasonNumber: 1)

        #expect(endpoint.path == "/tv/1/season/1/watch/providers")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvEpisodeDetails endpoint")
    func tmdbTvEpisodeDetailsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvEpisodeDetails(seriesId: 1, seasonNumber: 1, episodeNumber: 1, appendToResponse: "value", language: "value")

        #expect(endpoint.path == "/tv/1/season/1/episode/1")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvEpisodeAccountStates endpoint")
    func tmdbTvEpisodeAccountStatesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvEpisodeAccountStates(seriesId: 1, sessionId: "value", seasonNumber: 1, episodeNumber: 1, guestSessionId: "value")

        #expect(endpoint.path == "/tv/1/season/1/episode/1/account_states")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvEpisodeChangesById endpoint")
    func tmdbTvEpisodeChangesByIdBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvEpisodeChangesById(episodeId: 1)

        #expect(endpoint.path == "/tv/episode/1/changes")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("TvEpisodeCredits endpoint")
    func tmdbTvEpisodeCreditsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvEpisodeCredits(seriesId: 1, seasonNumber: 1, language: "value", episodeNumber: 1)

        #expect(endpoint.path == "/tv/1/season/1/episode/1/credits")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvEpisodeExternalIds endpoint")
    func tmdbTvEpisodeExternalIdsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvEpisodeExternalIds(seriesId: 1, seasonNumber: 1, episodeNumber: "value")

        #expect(endpoint.path == "/tv/1/season/1/episode/value/external_ids")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("TvEpisodeImages endpoint")
    func tmdbTvEpisodeImagesBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvEpisodeImages(seriesId: 1, includeImageLanguage: "value", language: "value", seasonNumber: 1, episodeNumber: 1)

        #expect(endpoint.path == "/tv/1/season/1/episode/1/images")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvEpisodeTranslations endpoint")
    func tmdbTvEpisodeTranslationsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvEpisodeTranslations(seriesId: 1, seasonNumber: 1, episodeNumber: 1)

        #expect(endpoint.path == "/tv/1/season/1/episode/1/translations")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("TvEpisodeVideos endpoint")
    func tmdbTvEpisodeVideosBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvEpisodeVideos(seriesId: 1, includeVideoLanguage: "value", language: "value", seasonNumber: 1, episodeNumber: 1)

        #expect(endpoint.path == "/tv/1/season/1/episode/1/videos")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvEpisodeAddRating endpoint")
    func tmdbTvEpisodeAddRatingBuildsEndpoint() throws {
        let endpoint = try Endpoint.tmdbTvEpisodeAddRating(seriesId: 1, guestSessionId: "value", sessionId: "value", contentType: "value", seasonNumber: 1, episodeNumber: 1, body: TMDBTvEpisodeAddRatingRequestDTO())

        #expect(endpoint.path == "/tv/1/season/1/episode/1/rating")
        #expect(endpoint.method == .post)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body != nil)
    }

    @Test("TvEpisodeDeleteRating endpoint")
    func tmdbTvEpisodeDeleteRatingBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvEpisodeDeleteRating(seriesId: 1, contentType: "value", guestSessionId: "value", sessionId: "value", seasonNumber: 1, episodeNumber: 1)

        #expect(endpoint.path == "/tv/1/season/1/episode/1/rating")
        #expect(endpoint.method == .delete)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("TvEpisodeGroupDetails endpoint")
    func tmdbTvEpisodeGroupDetailsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbTvEpisodeGroupDetails(tvEpisodeGroupId: "value")

        #expect(endpoint.path == "/tv/episode_group/value")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == true)
        #expect(endpoint.body == nil)
    }

    @Test("WatchProvidersAvailableRegions endpoint")
    func tmdbWatchProvidersAvailableRegionsBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbWatchProvidersAvailableRegions(language: "value")

        #expect(endpoint.path == "/watch/providers/regions")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("WatchProvidersMovieList endpoint")
    func tmdbWatchProvidersMovieListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbWatchProvidersMovieList(language: "value", watchRegion: "value")

        #expect(endpoint.path == "/watch/providers/movie")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

    @Test("WatchProviderTvList endpoint")
    func tmdbWatchProviderTvListBuildsEndpoint() throws {
        let endpoint = Endpoint.tmdbWatchProviderTvList(language: "value", watchRegion: "value")

        #expect(endpoint.path == "/watch/providers/tv")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty == false)
        #expect(endpoint.body == nil)
    }

}
