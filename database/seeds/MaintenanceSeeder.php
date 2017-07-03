<?php

use Illuminate\Database\Seeder;

class MaintenanceSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $modes = [
            [
                'status' => false,
                'message' => 'maintenance',
            ]
        ];
        DB::table('maintenance_status')->insert($modes);
    }
}
