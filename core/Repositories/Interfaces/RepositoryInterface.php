<?php

namespace Core\Repositories\Interfaces;

interface RepositoryInterface
{
    /**
     * Get all
     *
     * @return mixed
     */
    public function getAll();

    /**
     * Get one
     *
     * @param $id Id
     *
     * @return mixed
     */
    public function find($id);

    /**
     * Create
     *
     * @param array $attributes attributes
     *
     * @return mixed
     */
    public function create(array $attributes);

    /**
     * Update
     *
     * @param $id         id
     * @param array $attributes attributes
     *
     * @return mixed
     */
    public function update($id, array $attributes);

    /**
     * Delete
     *
     * @param $id id
     *
     * @return mixed
     */
    public function delete($id);
}
