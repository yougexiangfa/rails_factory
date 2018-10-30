class RailsFactoryInit < ActiveRecord::Migration[5.2]
  def change

    create_table :goods do |t|
      t.string :name
      t.string :desc #
      t.string :qr_prefix
      t.string :sku, index: true
      t.string :type
      t.integer :order_items_count, default: 0
      t.boolean :published, default: true
      t.references :good_taxon
      t.decimal :price, precision: 10, scale: 2
      t.decimal :import_price, precision: 10, scale: 2
      t.decimal :profit_price, precision: 10, scale: 2
      t.timestamps
    end

    create_table :customs do |t|
      t.string :name
      t.references :customer, polymorphic: true
      t.string :state
      t.string :qr_code
      t.datetime :ordered_at
      t.timestamps
    end

    create_table :good_taxons do |t|
      t.string :name
      t.string :type
      t.integer :position, default: 1
      t.references :parent
      t.timestamps
    end

    create_table :good_taxon_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end
    add_index :good_taxon_hierarchies, [:ancestor_id, :descendant_id, :generations], unique: true, name: 'good_taxon_anc_desc_idx'
    add_index :good_taxon_hierarchies, [:descendant_id], name: 'good_taxon_desc_idx'

    create_table :product_parts do |t|
      t.references :product
      t.references :part
      t.timestamps
    end

    create_table :custom_parts do |t|
      t.references :custom
      t.references :part
      t.timestamps
    end

    create_table :product_items do |t|
      t.references :product
      t.string :qr_code
      t.string :state
      t.datetime :produced_at
      t.timestamps
    end

    create_table :part_items do |t|
      t.references :part
      t.references :product_item
      t.string :qr_code
      t.string :state
      t.datetime :received_at
      t.timestamps
    end

    create_table :part_plans do |t|
      t.references :part
      t.datetime :start_at
      t.datetime :finish_at
      t.string :state
      t.integer :purchased_count, default: 0
      t.integer :received_count, default: 0
      t.timestamps
    end

    create_table :product_plans do |t|
      t.references :product
      t.datetime :start_at
      t.datetime :finish_at
      t.string :state
      t.integer :planned_count, default: 0
      t.integer :produced_count, default: 0
      t.timestamps
    end

  end
end
