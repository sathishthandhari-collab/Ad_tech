
{% set models_to_generate = codegen.get_models(directory='C:\Users\Sathish\OneDrive\Desktop\DA\Projects\Ad_tech\DBT_Transformation\adtech_data_transformation\models\intermediate\int_business_analytics__model_eph', prefix='int_') %}
{{ codegen.generate_model_yaml(
    model_names = models_to_generate
) }}
