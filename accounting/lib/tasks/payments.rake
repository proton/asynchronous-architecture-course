task pay_daily_salary: :environment do
  Account.where('balance > 0').find_each do |account|
    account.audit_logs.create!(delta: -account.balance, description: 'Balance paid', kind: 'BalancePaid')
  end
end