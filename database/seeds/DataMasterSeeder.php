<?php

use Illuminate\Database\Seeder;
use Illuminate\Database\Eloquent\Model;

class DataMasterSeeder extends Seeder {

    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run() {
        $tables = [
            'maintenance_status',
        ];

        DB::statement('SET FOREIGN_KEY_CHECKS=0;');
        foreach ($tables as $table) {
            DB::table($table)->truncate();
        }

        $this->call(MaintenanceSeeder::class);
    }

}
