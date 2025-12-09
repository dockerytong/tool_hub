# tool_hub

本仓库汇集了用于计算化学、分子动力学模拟、高性能计算任务调度及数据分析的工具脚本和应用程序。

## 📂 目录结构说明

本仓库包含以下主要模块：

### 1. 数据分析与可视化
*   **FTICR-shinny.zip**: 一个基于 R Shiny 框架开发的分析管道压缩包，专门用于处理和分析 FT-ICR（傅里叶变换离子回旋共振）质谱数据。
*   **R/**: 包含相关的 R 语言脚本，用于数据处理或辅助上述分析流程。

### 2. 分子动力学与模拟
*   **ASE/**: 基于 ASE (Atomic Simulation Environment) 的脚本集合，包含结合 MACE (Machine Learning Force Fields) 势函数的分子动力学模拟脚本。
*   **abcluster/**: 用于运行 ABCluster（原子团簇全局优化程序）的任务脚本，支持通过 Docker 容器化环境运行。
*   **VASP/**: 针对 VASP (Vienna Ab initio Simulation Package) 第一性原理计算软件的辅助文件或工具。

### 3. 高性能计算 (HPC)
*   **SLURM/**: 适用于 Slurm 作业调度系统的提交脚本，用于在集群上自动化部署上述计算任务（如 ASE-MACE 模拟）。

## 🚀 使用说明

*   **FT-ICR 分析**: 请解压 `FTICR-shinny.zip` 并按照 R Shiny 应用的标准流程运行。
*   **脚本运行**: 各目录下的脚本（Python/R/Shell）需根据具体计算环境配置依赖库（如 `ase`, `mace`, `docker` 等）。
