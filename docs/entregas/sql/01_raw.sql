SELECT DATABASE();

CREATE TABLE raw_orig_2020 (
    credit_score VARCHAR(255),
    first_payment_date VARCHAR(255),
    first_time_homebuyer_flag VARCHAR(255),
    maturity_date VARCHAR(255),
    msa VARCHAR(255),
    mi_percentage VARCHAR(255),
    number_of_units VARCHAR(255),
    occupancy_status VARCHAR(255),
    original_cltv VARCHAR(255),
    original_dti VARCHAR(255),
    original_upb VARCHAR(255),
    original_ltv VARCHAR(255),
    original_interest_rate VARCHAR(255),
    channel VARCHAR(255),
    ppm_flag VARCHAR(255),
    amortization_type VARCHAR(255),
    property_state VARCHAR(255),
    property_type VARCHAR(255),
    postal_code VARCHAR(255),
    loan_sequence_number VARCHAR(255),
    loan_purpose VARCHAR(255),
    original_loan_term VARCHAR(255),
    number_of_borrowers VARCHAR(255),
    seller_name VARCHAR(255),
    servicer_name VARCHAR(255),
    super_conforming_flag VARCHAR(255),
    pre_relief_refinance_loan_sequence_number VARCHAR(255),
    special_eligibility_program VARCHAR(255),
    relief_refinance_indicator VARCHAR(255),
    property_valuation_method VARCHAR(255),
    interest_only_indicator VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS raw_perf_2020 (
    loan_sequence_number VARCHAR(255),
    monthly_reporting_period VARCHAR(255),
    current_actual_upb VARCHAR(255),
    current_loan_delinquency_status VARCHAR(255),
    loan_age VARCHAR(255),
    remaining_months_to_legal_maturity VARCHAR(255),
    defect_settlement_date VARCHAR(255),
    modification_flag VARCHAR(255),
    zero_balance_code VARCHAR(255),
    zero_balance_effective_date VARCHAR(255),
    current_interest_rate VARCHAR(255),
    current_non_interest_bearing_upb VARCHAR(255),
    due_date_last_paid_installment VARCHAR(255),
    mi_recoveries VARCHAR(255),
    net_sale_proceeds VARCHAR(255),
    non_mi_recoveries VARCHAR(255),
    total_expenses VARCHAR(255),
    legal_costs VARCHAR(255),
    maintenance_preservation_costs VARCHAR(255),
    taxes_insurance VARCHAR(255),
    miscellaneous_expenses VARCHAR(255),
    actual_loss VARCHAR(255),
    cumulative_modification_cost VARCHAR(255),
    interest_rate_step_indicator VARCHAR(255),
    payment_deferral_flag VARCHAR(255),
    estimated_ltv VARCHAR(255),
    zero_balance_removal_upb VARCHAR(255),
    delinquent_accrued_interest VARCHAR(255),
    delinquency_due_to_disaster VARCHAR(255),
    borrower_assistance_status_code VARCHAR(255),
    current_month_modification_cost VARCHAR(255),
    interest_bearing_upb VARCHAR(255),
    mortgage_insurance_cancellation_indicator VARCHAR(255),
    servicer_name VARCHAR(255),
    bankruptcy_cramdown_costs VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS raw_orig_2021 LIKE raw_orig_2020;
CREATE TABLE IF NOT EXISTS raw_orig_2022 LIKE raw_orig_2020;
CREATE TABLE IF NOT EXISTS raw_orig_2023 LIKE raw_orig_2020;
CREATE TABLE IF NOT EXISTS raw_orig_2024 LIKE raw_orig_2020;

CREATE TABLE IF NOT EXISTS raw_perf_2021 LIKE raw_perf_2020;
CREATE TABLE IF NOT EXISTS raw_perf_2022 LIKE raw_perf_2020;
CREATE TABLE IF NOT EXISTS raw_perf_2023 LIKE raw_perf_2020;
CREATE TABLE IF NOT EXISTS raw_perf_2024 LIKE raw_perf_2020;
