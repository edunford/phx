
## Convenience API for the Cline Center Historical Phoenix Event Data v.1.0.

See the [Cline Center
website](https://clinecenter.illinois.edu/project/machine-generated-event-data-projects/phoenix-data)
for information on the Phoenix data curation and generation.

## Installation

``` r
devtools::install_github('edunford/phx')
```

## Getting Started

``` r
require(phx)
```

    ## Loading required package: phx

All `tap_` and `taste_` functions make a call to a currated sqlite
database. This database needs to be installed locally. This will take a
few minutes as the total data base is 969.6MB in size.

``` r
download_phx_db()
```

The codebook can be accessed at any time using

``` r
tap_codebook()
```

Once downloaded, there are two main function predicates:
`taste_<events/meta>` to preview data in the database and
`tap_<events/meta>` to extract the data from the database. `_events`
provide the raw event entries, whereas `_meta` provides the metadata for
each event entries. See code book for more details.

``` r
taste_events()
```

    ## # Source:   table<events> [?? x 26]
    ## # Database: sqlite 3.22.0
    ## #   [/Users/edunford/Dropbox/Programming/R_Packages/phx/data/phx_database.sqlite]
    ##    eid   date   year month   day source source_root source_agent
    ##    <chr> <chr> <int> <int> <int> <chr>  <chr>       <chr>       
    ##  1 FBIS… 2002…  2002     1    31 ---GOV <NA>        GOV         
    ##  2 FBIS… 1997…  1997    11    25 DEUGOV DEU         GOV         
    ##  3 FBIS… 2001…  2001     7    26 BIHLEG BIH         <NA>        
    ##  4 FBIS… 2000…  2000     2    10 SAUEL… SAU         <NA>        
    ##  5 FBIS… 1997…  1997     2    12 ---UAF <NA>        <NA>        
    ##  6 FBIS… 1997…  1997     3    13 ---MIL <NA>        MIL         
    ##  7 FBIS… 1999…  1999    12    19 ---COP <NA>        COP         
    ##  8 FBIS… 1997…  1997     3    11 ---GO… <NA>        GOV         
    ##  9 FBIS… 1996…  1996     7    11 ---JEW <NA>        <NA>        
    ## 10 FBIS… 1999…  1999     8    14 ---MU… <NA>        <NA>        
    ## # … with more rows, and 18 more variables: source_others <chr>,
    ## #   target <chr>, target_root <chr>, target_agent <chr>,
    ## #   target_others <chr>, code <chr>, root_code <chr>, quad_class <int>,
    ## #   goldstein <dbl>, joined_issues <chr>, lat <dbl>, lon <dbl>,
    ## #   placename <chr>, statename <chr>, countryname <chr>, aid <int>,
    ## #   process <chr>, database <chr>

``` r
taste_meta()
```

    ## # Source:   table<titles> [?? x 5]
    ## # Database: sqlite 3.22.0
    ## #   [/Users/edunford/Dropbox/Programming/R_Packages/phx/data/phx_database.sqlite]
    ##        aid title                      primary_source original_source date  
    ##      <int> <chr>                      <chr>          <chr>           <chr> 
    ##  1 1740084 ALASKA STAMP SALE SET; Ai… NYT            NYT             1959-…
    ##  2 1740086 ARGENTINE OFFICE OF DU PO… NYT            NYT             1959-…
    ##  3 1740099 Balloons Herald '59 March… NYT            NYT             1959-…
    ##  4 1740101 Bankers Join Fight for Co… NYT            NYT             1959-…
    ##  5 1740102 BARNES TENNIS VICTOR; Bra… NYT            NYT             1959-…
    ##  6 1740124 Canadian Stock Barred      NYT            NYT             1959-…
    ##  7 1740127 Celebes Rebels Attacked    NYT            NYT             1959-…
    ##  8 1740148 CUBAN ARMY SAYS REBELS QU… NYT            NYT             1959-…
    ##  9 1740149 Cullman Joins Board Of Na… NYT            NYT             1959-…
    ## 10 1740150 DEFENSE POWERS STIR FEAR … NYT            NYT             1959-…
    ## # … with more rows

\[More getting started information to follow\!\]

## Citations

  - **Data citation**: Althaus, Scott, Joseph Bajjalieh, John F. Carter,
    Buddy Peyton, and Dan A. Shalmon. 2017. Cline Center Historical
    Phoenix Event Data. v.1.0.0. Distributed by Cline Center for
    Advanced Social Research. June 30.
    <http://www.clinecenter.illinois.edu/data/event/phoenix/>.

  - **Codebook citation**: Althaus, Scott, Joseph Bajjalieh, John F.
    Carter, Buddy Peyton, and Dan A. Shalmon. 2017. “Cline Center
    Historical Phoenix Event Data Variable Descriptions”. Cline Center
    Historical Phoenix Event Data. v.1.0.0. Cline Center for Advanced
    Social Research. June 30.
    <http://www.clinecenter.illinois.edu/data/event/phoenix/>
