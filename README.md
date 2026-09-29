## Структура проекта

```
iis/
├── data/                 # исходные и очищенные данные (НЕ в git)
├── eda/                  # разведочный анализ
│   ├── eda.ipynb
│   └── graph*.png/.html
├── research/             # эксперименты и настройка модели
│   └── research.ipynb
├── mlflow/               # запуск MLflow Tracking Server
│   └── start_mlflow.sh
├── requirements.txt
├── README.md
└── .gitignore
```

## Запуск

### 1. Клонирование и окружение

```bash
git clone https://github.com/Xereer/iis.git
cd iis

python3 -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate

pip install -r requirements.txt
```

### 2. Данные

Файлы с данными в репозиторий не коммитятся. Положите их в `./data`:

- `data/dataset.csv` — исходный датасет
- `data/clean_data.pkl` — очищенный датасет после EDA

Если `clean_data.pkl` нет — выполните ноутбук `eda/eda.ipynb` (он сохранит pickle).

### 3. EDA (ЛР1)

```bash
source .venv/bin/activate
cd eda
jupyter notebook eda.ipynb
```

### 4. MLflow (ЛР2)

```bash
source .venv/bin/activate
cd mlflow
sh start_mlflow.sh
```

UI: http://127.0.0.1:5001/

### 5. Исследование моделей

В отдельном терминале (с активированным `.venv` и запущенным MLflow):

```bash
cd research
jupyter notebook research.ipynb
```

Ноутбук читает данные из `../data/clean_data.pkl`.

## Результаты EDA

### Очистка данных
- удалены полные дубликаты;
- типы приведены к `category` / `int32`;
- отфильтрованы невалидные значения цены и пробега;
- пропусков в исходных данных не было.

### Новые признаки
- `Driven_run` — категория пробега (`low` / `mid` / `hi`) по квантилям `Driven_kms`.

### Основные закономерности
- `Present_Price` — сильнейший предиктор `Selling_Price`;
- более новые авто (`Year`) продаются дороже;
- Diesel и Dealer связаны с более высокой ценой;
- `Car_Name` и `Transmission` влияют на цену;
- пробег влияет слабее числом, но полезен как категория `Driven_run`.

Графики сохранены в `eda/`.

## Результаты исследования (ЛР2)

В `research/research.ipynb` выполнены:
1. Baseline: `StandardScaler` + `OrdinalEncoder` + `RandomForestRegressor`
2. Feature engineering (sklearn): PolynomialFeatures, QuantileTransformer, SplineTransformer
3. Feature selection: экспертный отбор признаков по результатам EDA
4. Подбор гиперпараметров: Optuna (≥10 trials, minimize MAE)
5. Финальная модель обучается на всей выборке и регистрируется в Model Registry с alias/тегом **Production**

Отобранные признаки: см. `research/selected_skl_cols.txt`.

После прогона ноутбука:
- сравните runs в UI MLflow;
- сохраните скриншоты `research/model_runs.png` и `research/model_versions.png`;
- скачайте `MLmodel` Production-версии в `research/mlmodel_file`.

## Примечания
- Данные (`.csv`, `.pkl`) и артефакты MLflow (`mlruns.db`, `mlartifacts/`) не коммитятся — храните их отдельно (флешка / облако).
- Скрипт `mlflow/start_mlflow.sh` должен быть в репозитории и запускаться из каталога `mlflow/`.
