shinyServer(function(input, output, session) {
    
    output$keggPathways <- renderDataTable({
        DT::datatable(paths.hsa, selection = 'single')
    })
    
    geneList <- reactive({
        df <- read.csv(input$file1$datapath, header = input$header) %>% unlist() %>% as.character()
        if(input$species == 'Mouse'){
            df = tools::toTitleCase(df)
        } else if(input$species == 'Human'){
            df = toupper(df)
        }
        return(df)
    })
    
    output$contents <- renderText({geneList()})
    
    output$plot1 <- renderImage({
        currentFiles <- list.files('.')
        png <- grep('.png',currentFiles)
        if(length(png) > 0){
            file.remove(currentFiles[png])
        }
        
        xml <- grep('.xml',currentFiles)
        if(length(xml) > 0){
            file.remove(currentFiles[xml])
        }
        
        pw <- input$keggPathways_rows_selected
        pathwayID <- paths.hsa[pw,1] %>% unlist() %>% as.character()
        keggSpecies <- filter(species, common.name == tolower(input$species))[,1] %>% unlist() %>% as.character()
        
        convGenes <- id2eg(ids = geneList(), category = input$geneFormat, org = input$species)
        convGenes <- as.matrix(convGenes)[,2]
        convGenes <- convGenes[!is.na(convGenes)]
        
        genes <- rep(2, length(convGenes))
        names(genes) <- convGenes
        
        pathview(gene.data = convGenes, species = keggSpecies, pathway.id = pathwayID, out.suffix = 'KEGG')
        
        imageFile <- list.files('.')[grep('KEGG.png',list.files('.'))]
        list(src = imageFile)
    }, deleteFile = FALSE)
    
    
   
    # keggOutput <- eventReactive(input$submit, {
    #     
    #     currentFiles <- list.files('.')
    #     png <- grep('.png',currentFiles)
    #     if(length(png) > 0){
    #         file.remove(currentFiles[png])
    #     }
    #     
    #     xml <- grep('.xml',currentFiles)
    #     if(length(xml) > 0){
    #         file.remove(currentFiles[xml])
    #     }
    #     
    #     pw <- input$keggPathways_rows_selected
    #     pathwayID <- paths.hsa[pw,1] %>% unlist() %>% as.character()
    #     keggSpecies <- filter(species, common.name == tolower(input$species))[,1] %>% unlist() %>% as.character()
    #     
    #     convGenes <- id2eg(ids = geneList(), category = input$geneFormat, org = input$species)
    #     convGenes <- as.matrix(convGenes)[,2]
    #     convGenes <- convGenes[!is.na(convGenes)]
    #     
    #     genes <- rep(2, length(convGenes))
    #     names(genes) <- convGenes
    #     
    #     pathview(gene.data = convGenes, species = keggSpecies, pathway.id = pathwayID, out.suffix = 'KEGG')
    # })
    # 
    # output$plot1 <- renderImage({
    #     keggOutput()
    # })
    # 
    #  output$plotx <- eventReactive(input$submit, renderImage({
    #      imageFile <- list.files('.')[grep('KEGG.png',list.files('.'))]
    #      list(src = imageFile)
    #  }, deleteFile = FALSE))
     
})
