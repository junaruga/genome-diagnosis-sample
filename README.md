## Genome Diagnosis Sample

This is the sample code to analyze genetic risk factors from one profile's genome string.
As the Analysis log is simpliped, comparison by 3 base pair unit, or recommendation by machine learning are not implemented.

## Getting Started

To run this project, You need to install Perl and Carton (Perl package manager).

### Install Perl and Carton

According to installing  perl using perlbrew, and carton, please refer my blog article.
=> [Blog | Set up Perl development environment](http://junaruga.hatenablog.com/entry/2014/08/23/030632)

### Run this project\'s program

Change your git directory, and download files.

    $ cd $GIT_DIR
    $ git clone https://github.com/junaruga/genome-diagnosis-sample.git
    $ cd genome-diagnosis-sample/

Run the script which generate genome data for test.

    $ bin/appperl script/generate_genome.pl

You can use following generate_genome.pl command options.

| Option | Decription |
|--------------| -----------------------|
| -n | generated genome data number (Default: 100) |
| --debug | Output debug message |


Check generated genome data file.

	$ ls -l data/genomes.json
	$ view data/genomes.json

Run the script which anlyze wether variant is present for one profile's genome string.

    $ bin/appperl script/print_genetic_risk_factors.pl

You can use following print_genetic_risk_factors.pl command options.

| Option | Decription |
|--------------| -----------------------|
| -p | profile_id (required). See genomes.json |
| --debug | Output debug message |

Running Sample

    $ bin/appperl script/print_genetic_risk_factors.pl -p 3
    ------------------------------------------------------------
    Genetic Risk Factors
    ------------------------------------------------------------
    Diabetes,                Variant Present, Risk: 100% (Total: 1, Found: 1)
    Heart disease,           Variant Present, Risk: 80% (Total: 5, Found: 4)
    Cancer,                  Variant Present, Risk: 100% (Total: 1, Found: 1)
    Alzheimer,               Variant Present, Risk: 67% (Total: 3, Found: 2)
    ------------------------------------------------------------

That's it.














