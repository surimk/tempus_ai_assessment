FROM --platform=linux/amd64 continuumio/miniconda3:latest

WORKDIR /app

COPY environment.yaml /app/environment.yaml

RUN conda update -n base -c defaults conda -y && \
    conda env update --name base --file /app/environment.yaml && \
    conda clean --all -y

CMD ["/bin/bash"]