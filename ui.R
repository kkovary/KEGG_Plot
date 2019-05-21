shinyUI(fluidPage(
    titlePanel("KEGG Pathway Search"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            fileInput("file1", "Upload Gene List (CSV File)",
                      multiple = FALSE,
                      accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
            checkboxInput("header", "Header", FALSE),
            selectInput("geneFormat", "Select your gene format:", choices = gene.idtype.list),
            selectInput("species", "Select your species of interest:", choices = c('Mouse','Human'), selected = 'Mouse'),
            tags$hr(),
            helpText('Click on the pathway of interest:'),
            tabPanel('KEGG Pathways', DT::dataTableOutput('keggPathways'))
            ),

        mainPanel(
            tableOutput("contents"),
            plotOutput('plot1')
        )
    )
))
