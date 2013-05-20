class Department < ActiveRecord::Base

  default_scope order('name ASC')

  attr_accessible :description, :name
  validates :name, :presence => true, :uniqueness => true
  has_many :openings, :dependent => :destroy

  has_many :users, :dependent => :destroy

  scope :with_openings, joins(:openings).uniq

  scope :with_users, joins(:users).uniq


  DEFAULT_SET = [ { name: 'Admin', description: 'Administrative' },
                  { name: 'Customer Support', description: 'Customer Support' },
                  { name: 'Design', description: 'Design' },
                  { name: 'Facilities', description: 'Facilities' },
                  { name: 'Finance & Accounting', description: 'Finance & Accounting' },
                  { name: 'HR', description: 'Human Resources' },
                  { name: 'IT', description: 'IT' },
                  { name: 'Legal', description: 'Legal' },
                  { name: 'Logistics', description: 'Logistics' },
                  { name: 'Marketing', description: 'Marketing' },
                  { name: 'Product', description: 'Product' },
                  { name: 'Project Management', description: 'Project Management' },
                  { name: 'R & D', description: 'Research and Developing' },
                  { name: 'Sales', description: 'Sales' },
                  { name: 'Others', description: 'Others' },
  ]


end
