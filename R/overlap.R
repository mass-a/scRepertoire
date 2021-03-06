#' Examining the clonal overlap between groups or samples
#'
#' This functions allows for the caclulation and visualizations of the 
#' overlap coefficient or morisita index for clonotypes using the product 
#' of combineTCR(), combineBCR() or expression2list(). The overlap 
#' coefficient is calculated using the intersection of clonotypes 
#' divided by the length of the smallest componenet. Morisita index is 
#' estimating the dispersion of a population, more information can be found 
#' [here](https://en.wikipedia.org/wiki/Morisita%27s_overlap_index).
#' If a matrix output for the data is preferred, set exportTable = TRUE.
#'
#' @examples
#' #Making combined contig data
#' x <- contig_list
#' combined <- combineTCR(x, rep(c("PX", "PY", "PZ"), each=2), 
#' rep(c("P", "T"), 3), cells ="T-AB")
#' 
#' clonalOverlap(combined, cloneCall = "gene", method = "overlap")
#'
#' @param df The product of combineTCR(), combineBCR(),  or expression2List().
#' @param cloneCall How to call the clonotype - CDR3 gene (gene), 
#' CDR3 nucleotide (nt) or CDR3 amino acid (aa), or 
#' CDR3 gene+nucleotide (gene+nt).
#' @param method The method to calculate the overlap, either the overlap 
#' coefficient or morisita index.
#' @param exportTable Exports a table of the data into the global 
#' environment in addition to the visualization
#' @importFrom stringr str_sort
#' @importFrom reshape2 melt
#' @export
#' @return ggplot of the clonotypic overlap between elements of a list
clonalOverlap <- function(df, cloneCall = c("gene", "nt", "aa", "gene+nt"), 
                                method = c("overlap", "morisita"), 
                                exportTable = FALSE){
    cloneCall <- theCall(cloneCall)
    df <- checkBlanks(df, cloneCall)
    df <- df[order(names(df))]
    values <- str_sort(as.character(unique(names(df))), numeric = TRUE)
    df <- df[quiet(dput(values))]
    num_samples <- length(df[])
    names_samples <- names(df)
    coef_matrix <- data.frame(matrix(NA, num_samples, num_samples))
    colnames(coef_matrix) <- names_samples
    rownames(coef_matrix) <- names_samples
    length <- seq_len(num_samples)
    if (method == "overlap") {
        coef_matrix <- overlapIndex(df, length, cloneCall, coef_matrix)
    } else if (method == "morisita") {
        coef_matrix <- morisitaIndex(df, length, cloneCall, coef_matrix)}
    coef_matrix$names <- rownames(coef_matrix)
    if (exportTable == TRUE) { return(coef_matrix) }
    coef_matrix <- suppressMessages(melt(coef_matrix))[,-1]
    col <- colorblind_vector(7)
    coef_matrix$variable <- factor(coef_matrix$variable, levels = values)
    coef_matrix$names <- factor(coef_matrix$names, levels = values)
    plot <- ggplot(coef_matrix, aes(x=names, y=variable, fill=value)) +
            geom_tile() + labs(fill = method) +
            geom_text(aes(label = round(value, digits = 3))) +
            scale_fill_gradient2(high = col[1], mid = col[4], 
                    midpoint = ((range(na.omit(coef_matrix$value)))/2)[2], 
                    low=col[7], na.value = "white") +
            theme_classic() + theme(axis.title = element_blank())
    return(plot) }
