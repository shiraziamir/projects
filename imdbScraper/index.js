//const request = require("request-promise");
const request = require("requestretry").defaults({ fullResponse: false });
const cheerio = require("cheerio");
const Nightmare = require("nightmare");
const nightmare = Nightmare({ show: true });

async function scrapeTitlesRankAndRatings() {
  const result = await request.get("https://www.imdb.com/chart/moviemeter/?ref_=nv_mv_mpm");
  const $ = await cheerio.load(result);

  const movies = $("tr")
    .map((i, element) => {
      const title = $(element)
        .find("td.titleColumn > a")
        .text();
      if (title === '') return;
      const descriptionUrl = "https://www.imdb.com" + $(element)
        .find("td.titleColumn > a")
        .attr("href");
      const imdbRating = $(element)
        .find("td.ratingColumn.imdbRating")
        .text()
        .trim();
      return { title, imdbRating, rank: i, descriptionUrl };
    }).get();
  return movies;
}

async function scrapePosterUrl(movies) {
  return await Promise.all(
    movies.map(async (movie, i) => {

      try {
        const html = await request.get(movie.descriptionUrl);
        const $ = await cheerio.load(html);
        movie.posterUrl = "https://www.imdb.com" + $("div.poster > a").attr("href");
        //console.log(i);
        return movie;
      } catch (err) {
        console.error(err)
      }
    }))
}

async function scrapePosterImageUrl(movies) {
  for (var i = 0; i < movies.length; i++) {
    try {
      const posterImageUrl = await nightmare
        .goto(movies[i].posterUrl)
        .evaluate(() => 
            $(
             "#photo-container > div > div:nth-child(3) > div > div.pswp__scroll-wrap > div.pswp__container > div:nth-child(2) > div > img:nth-child(2)"
             ).attr("src")
        );
      movies[i].posterImageUrl = posterImageUrl;
      console.log(movies[i])
    } catch (err) {
      console.error(err)
    }
    return movies;
  }
}

async function main() {
  let movies = await scrapeTitlesRankAndRatings();
  movies = await scrapePosterUrl(movies);
  movies = await scrapePosterImageUrl(movies);
  //console.log(movies)
}
main();