# Use the official R base image
FROM rocker/r-ver:4.3.2

# Install system dependencies for R package compilation
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    build-essential \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Install R package dependencies
RUN R -e "install.packages(c('Rcpp', 'shiny', 'dplyr'), repos='https://cran.rstudio.com/')"

# Create app directory
WORKDIR /app

# Copy the entire package
COPY . /app

# Build and install the stringproc package
RUN R CMD INSTALL /app

# Expose the Shiny app port
EXPOSE 3838

# Run the Shiny app
CMD ["R", "-e", "stringproc::run_lcs_app(host='0.0.0.0', port=3838)"]
