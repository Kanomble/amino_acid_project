# use clusterProfiler for gene enrichment analysis
library(clusterProfiler)
output_dir <- "results/gene_enrichment_analysis/hydra_mono/"

# read WP to AEP translation table and deseq2 dataframe
translation_table <- read.csv("data/curvibacter_annotation_files/translation_table_corrected.csv", sep="\t")
deseq_df <- read.csv("results/rsem/hydra_mono_culture_kiel_vs_liquid_mono_culture_kiel.csv")

# read data from the BLASTKoala tool
ko_mapping_df <- read.csv("data/curvibacter_annotation_files/kegg_curvibacter/curvibacter_wps_to_kegg.txt", sep = "\t")
ko_universe <- ko_mapping_df$ko

# rename deseq2 identifier to correct AEP identifier (without the gene: prefix)
deseq_df$X <- sapply(strsplit(as.character(deseq_df$X), "gene:"), function(x) x[2])
colnames(deseq_df)[colnames(deseq_df) == "X"] <- "old_locus_tag"
# filter all significant genes
deseq_df <- deseq_df[deseq_df$padj <= 0.05, ]

# merge translation table and deseq2 dataframe to get a WP to AEP identifier mapping in the deseq2 dataframe
merged_df <- merge(deseq_df, translation_table, by = "old_locus_tag")
# get KO numbers for all WP identifier
merged_df <- merge(merged_df, ko_mapping_df, by="protein_id")


# genes upregulated on host
upregulated <- merged_df[merged_df$log2FoldChange >= 1, ]

# writing upregulated into file
combined <- cbind(upregulated[upregulated$ko != "", ]$protein_id, upregulated[upregulated$ko != "", ]$ko)
write.csv(combined, "results/gene_enrichment_analysis/hydra_mono/hydra_mono_upregulated_kegg_ids.txt")

kegg_enrich_result <- enrichKEGG(gene = upregulated$ko, universe = ko_universe, organism = 'ko')
write.csv(kegg_enrich_result@result,"results/gene_enrichment_analysis/hydra_mono/kegg_enrich_upregulated.csv")

png(file=file.path(output_dir,paste0("curvibacter_kegg_upregulated_on_host.png")), width=800, height=550)
dotplot <- dotplot(kegg_enrich_result, showCategory=20)
print(dotplot)
dev.off()

# genes downregulated on host
downregulated <- merged_df[merged_df$log2FoldChange <= -1, ]

# writing upregulated into file
combined <- cbind(downregulated[downregulated$ko != "", ]$protein_id, downregulated[downregulated$ko != "", ]$ko)
write.csv(combined, "results/gene_enrichment_analysis/hydra_mono/hydra_mono_downregulated_kegg_ids.txt")

kegg_enrich_result <- enrichKEGG(gene = downregulated$ko, universe = ko_universe, organism = 'ko')
write.csv(kegg_enrich_result@result,"results/gene_enrichment_analysis/hydra_mono/kegg_enrich_downregulated.csv")

png(file=file.path(output_dir,paste0("curvibacter_kegg_downregulated_on_host.png")), width=800, height=550)
dotplot <- dotplot(kegg_enrich_result, showCategory=20)
print(dotplot)
dev.off()