# stringproc

> String Processing and Longest Common Subsequence Analysis

[![License: GPL-3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## Overview

`stringproc` provides efficient tools for string processing with a focus on finding the longest common subsequence (LCS) between two strings. The package combines a fast C++ implementation (via Rcpp) with an interactive Shiny application for visualizing string comparisons.

## Features

- **Fast LCS Algorithm**: Efficient C++ implementation for computing the longest common subsequence
- **Visual Comparison**: Color-coded highlighting of differences and similarities between strings
- **Interactive Interface**: Built-in Shiny application for exploring string comparisons in real-time
- **Case-Sensitive Options**: Toggle case sensitivity for flexible string matching
- **Detailed Output**: Returns aligned strings showing insertions, deletions, and matches

## Installation

### From source

```r
# Install development version from source
install.packages("devtools")
devtools::install_github("your-username/stringproc")
```

### Dependencies

The package requires:
- R (>= 3.5.0)
- Rcpp (>= 0.12.15)
- shiny (>= 1.7.0)
- dplyr (>= 1.0.0)

## Usage

### Basic Usage

Find the longest common subsequence between two strings:

```r
library(stringproc)

# Compare two strings
result <- longest_common_seq(
  "Lorem dolor sit amet, consectetur adipiscing elit.",
  "Lorem ipsum dolor sit amet, eu erat sed felis pharetra."
)

print(result)
```

**Output:**
```
x: Lorem dolor sit amet, consectetur adipiscing elit.
y: Lorem ipsum dolor sit amet, eu erat sed felis pharetra.
Longest Common Seq: Lorem dolor sit amet,  e  sed  li
Compare:
  x: Lorem- dolor sit amet, consectetur adipiscing elit.--------
  y: Lorem ipsum dolor sit amet, eu erat sed felis pharetra.
```

### Interactive Shiny Application

Launch the interactive Shiny app for visual string comparison:

```r
library(stringproc)

# Start the interactive application
run_lcs_app()
```

The Shiny app provides:
- Side-by-side text input areas
- Real-time comparison as you type
- Color-coded visualization:
  - **Beige** (#e0e0d1): Common characters in both strings
  - **Yellow** (#ffff99): Characters only in the first string
  - **Blue** (#99bbff): Characters only in the second string
  - **Red** (#ff9999): Different characters at the same position
- Case sensitivity toggle
- Display of the longest common subsequence

### Advanced Example

```r
# Case-insensitive comparison
text1 <- "The Quick Brown Fox"
text2 <- "the quick brown dog"

# Convert to lowercase for case-insensitive comparison
result <- longest_common_seq(
  tolower(text1),
  tolower(text2)
)

# Extract the common subsequence
common_seq <- as.character(result)
cat("Common sequence:", common_seq, "\n")

# Access detailed metadata
meta <- attr(result, "meta")
cat("Aligned string 1:", paste(meta$sx, collapse = ""), "\n")
cat("Aligned string 2:", paste(meta$sy, collapse = ""), "\n")
```

## How It Works

The longest common subsequence (LCS) algorithm finds the longest sequence of characters that appear in the same order in both strings, though not necessarily consecutively.

For example, comparing "ABCD" and "ACBD":
- The LCS is "ABD" (length 3)
- The strings are aligned to show the differences

The package uses dynamic programming implemented in C++ for optimal performance on large strings.

## Use Cases

- **Text comparison**: Compare different versions of documents
- **Diff tools**: Build custom diff utilities for text files
- **Data cleaning**: Identify similarities between messy text entries
- **Bioinformatics**: Sequence alignment (DNA, RNA, protein sequences)
- **Plagiarism detection**: Find common sections between documents
- **Version control**: Understand changes between text versions

## License

This package is licensed under GPL-3, ensuring compatibility with its dependencies:
- [shiny](https://cran.r-project.org/package=shiny) (GPL-3)
- [dplyr](https://cran.r-project.org/package=dplyr) (MIT + file LICENSE)

See the LICENSE file for full details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## References

- [Longest Common Subsequence Problem](https://en.wikipedia.org/wiki/Longest_common_subsequence_problem)
- [Dynamic Programming Approach](https://www.geeksforgeeks.org/longest-common-subsequence-dp-4/)

## Citation

If you use this package in your research, please cite it as:

```
@Manual{,
  title = {stringproc: String Processing and Longest Common Subsequence},
  author = {Package Author},
  year = {2024},
  note = {R package version 0.1.0},
}
```

---

For questions, issues, or feature requests, please open an issue on the GitHub repository.
