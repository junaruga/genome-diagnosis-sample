## Genome Diagnosis Sample

This is the sample code to analyze genetic risk factors from one profile's genome string.
As the Analysis log is simpliped, comparison by 3 base pair unit, or recommendation by machine learning are not implemented.

## Getting Started

To run this project, You need Perl and Carton (Perl package manager).

If you would like to use installed system perl as running environment, you can follow to step 1 and 2 simply.

If you would like to use another perl using perlview (perl version management 
tool), you can refer following blog article: perlbrew, cpanm, carton's sections instead of step 1 and 2. => [Blog | Set up Perl development environment](http://junaruga.hatenablog.com/entry/2014/08/23/030632)

1. Install cpanm

        $ curl -L http://cpanmin.us | perl - App::cpanminus
        $ which cpanm

2. Install Carton

        $ cpanm Carton
        $ which carton

3. Change your git directory, and download files.

        $ cd $GIT_DIR
        $ git clone https://github.com/junaruga/genome-diagnosis-sample.git
        $ cd genome-diagnosis-sample/

4. Install CPAN modules by Carton.

        $ make carton

5. Run the script which generate genome data for test.

        $ bin/appperl script/generate_genome.pl

    You can use following generate_genome.pl command options.

    | Option | Decription |
    |--------------| -----------------------|
    | -n | Generated genome data number (default: 100) |
    | --debug | Output debug message |

6. Check generated genome data file.

        $ ls -l data/genomes.json
        $ view data/genomes.json
        {
            "genomes" : {
                "base" : "GGAATGGCTTTCTAGCGTGACCCGTTGCGCGTGTGACGTTTTATTACGAGATAGGTATGCTCCGTCGCGTGTTCCATCACGTGCAAAGGCAAGTTATGCGTAGTTTCCTCGGCGGTATCGCCATACTCAGTCCCGCCATTTTCACACACCCTCATCGGCGGATGGGACGGTTAGAACCGGGCATTGGAGAACTAGCCCTCCGCCACAGACATCGATGGTCTTGTATTCGTAGGACGCTATTCGGGAATCATTAACCGATATGCTCCGCGCCACCAAACGCAGTTCAAGGCCAATGTTCGC",
                "genomes" : [
                    {
                        "profile_id" : 1,
                        "genome" : "GGAATGGCTTTTTATCGTGACCCGGTGCGCGTATCACGTTTTCTTACGAGATAGGTATGCTCCGTCGCGTGTTCCATCACGTGCAAAGGCAAGTTATGCGTAGTCTCCTCGGCGGTATCGCCATACTCAGTCCCGCCATTTTCACACACCCTCATCGGCGGATGGGACGGTTAGAACCGGGCATTGGAGAACTAGCCCTCCGCCACAGACATCGATGGTCTTGTATTCGTAGGACGCTATTCGGGAATCATTAACCGATATGCTCCGCGCCACCAAACGCAGTTCAAGGCCAATGTTCGC"
                    },
                    ...
                ]
            }
        }

7. Run the script which anlyze wether variant is present for one profile's genome string.

        $ bin/appperl script/print_genetic_risk_factors.pl -p {profile_id}

    You can use following print_genetic_risk_factors.pl command options.

    | Option | Decription |
    |--------------| -----------------------|
    | -p | profile_id (required). See genomes.json |
    | --debug | Output debug message |

    The following is the sample to run.

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

## Use this anlysis script by Web UI.

You can use this script from your browser.
If you want to use it from your browser, you can follow below way.

1. Install Mojolicious

    We are using [Mojolicious](http://mojolicio.us) as web application.
    Run following command.

        $ curl -L https://cpanmin.us | perl - -M https://cpan.metacpan.org -n Mojolicious

2. Run server.

        $ cd $GIT_DIR/genome-diagnosis-sample/
        $ make start-server

3. Access the web site.

    Access http://127.0.0.1:8080 from your browser.
