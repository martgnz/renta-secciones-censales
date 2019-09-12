const fs = require("fs");
const request = require("request");
const cheerio = require('cheerio');

const getURL = url => `https://www.ine.es/jaxiT3/files/t/es/csv/${url.substring(4, 9)}.csv`;

request.get('https://www.ine.es/experimental/atlas/exp_atlas_tab.htm', (err, response, html) => {
  if (err) throw err;

  const $ = cheerio.load(html);

  // algunas url parece que no se bajan bien
  // castellón y otra más están duplicadas y aparece otro archivo de población o0
  // por algún motivo melilla no sale y lo he bajado manualmente
  const urls = $('.inebase_capitulo:not(:first-child) > ol li:first-child')
    .map((idx, node) => getURL($(node).attr('id'))).toArray();

  fs.writeFile('./urls.txt', urls.join('\r\n'), (err) => {
    if (err) throw err;
    console.log('wrote urls!')
  });
});
