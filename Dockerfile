FROM ubuntu:20.04

# Update and upgrade distribution
RUN apt-get update && \
    apt-get upgrade -y

# Tools necessary for installing and configuring Ubuntu
RUN apt-get install -y \
    apt-utils \
    locales \
    tzdata


# Locale with UTF-8 support
RUN echo en_US.UTF-8 UTF-8 >> /etc/locale.gen && \
    locale-gen && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Required for Gudhi compilation
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y make \
    g++ \
    cmake \
    graphviz \
    perl \
    texlive-bibtex-extra \
    biber \
    libboost-all-dev \
    libeigen3-dev \
    libgmp3-dev \
    libmpfr-dev \
    libtbb-dev \
    libcgal-dev \
    locales \
    python3 \
    python3-pip \
    python3-pytest \
    python3-tk \
    python3-pybind11 \
    libfreetype6-dev \
    r-base \
    vim \
    build-essential \ 
    pkg-config \
    curl \
    imagemagick

RUN pip3 install --upgrade setuptools

RUN pip3 install \
    Cython \
    numpy \
    matplotlib \
    scipy
RUN pip3 install \
    POT \  
    sphinx \ 
    pykeops \ 
    eagerpy \
    hnswlib \
    scikit-learn

# apt clean up
RUN apt autoremove && rm -rf /var/lib/apt/lists/*

RUN curl -LO "https://github.com/GUDHI/gudhi-devel/releases/download/tags%2Fgudhi-release-3.2.0/gudhi.3.2.0.tar.gz" \
&& tar xf gudhi.3.2.0.tar.gz \
&& cd gudhi.3.2.0 \
&& mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release -DWITH_GUDHI_PYTHON=OFF -DPython_ADDITIONAL_VERSIONS=3 ..  \
&& make all test install \
&& cmake -DWITH_GUDHI_PYTHON=ON . \
&& cd python \
&& python3 setup.py install

RUN R -e "install.packages('TDA',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('spatstat.data',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('spatstat',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('scatterplot3d',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN apt-get update && apt-get install -y r-cran-rgl
# RUN apt-get update
# RUN apt-get install -y software-properties-common
# RUN add-apt-repository main
# RUN add-apt-repository universe
RUN echo 'library(TDA)' > .Rprofile
RUN echo 'library(spatstat)' >> .Rprofile
RUN echo 'library(rgl)' >> .Rprofile
RUN echo 'library(scatterplot3d)' >> .Rprofile
RUN echo 'source("functions.R")' >> .Rprofile
COPY datasets datasets
COPY ./scripts/functions.R /
# Build:
	# sudo docker build -t dtm .
# Run:
	# xhost +
	# sudo docker run --net=host -it --rm -e DISPLAY=$DISPLAY  -v /tmp/.X11-unix:/tmp/.X11-unix:ro dtm
# Copy file:
	# sudo docker cp FILENAME `sudo docker ps | grep _ | awk '{print $NF}'`:/
